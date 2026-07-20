#!/usr/bin/env python3
"""Merge OpenSCAD operation SVGs into one colour-classified SVG.

Separate SVG files remain authoritative. This utility preserves their shared
OpenSCAD coordinate system, expands the output viewBox to their union, and puts
each operation in a labelled group with the repository standard stroke colour.
"""

from __future__ import annotations

import argparse
import copy
from pathlib import Path
import xml.etree.ElementTree as ET


SVG_NS = "http://www.w3.org/2000/svg"
ET.register_namespace("", SVG_NS)

COLORS = {
    "cut": "#ff0000",
    "engrave": "#0000ff",
    "score": "#008000",
    "reference": "#808080",
}


def parse_operation(spec: str) -> tuple[str, Path]:
    try:
        operation, filename = spec.split("=", 1)
    except ValueError as exc:
        raise argparse.ArgumentTypeError(
            "operation inputs use OPERATION=FILE"
        ) from exc
    if operation not in COLORS:
        raise argparse.ArgumentTypeError(
            f"unsupported operation {operation!r}"
        )
    path = Path(filename)
    if not path.is_file():
        raise argparse.ArgumentTypeError(f"SVG does not exist: {path}")
    return operation, path


def view_box(root: ET.Element) -> tuple[float, float, float, float]:
    values = root.attrib.get("viewBox", "").split()
    if len(values) != 4:
        raise ValueError("input SVG has no four-value viewBox")
    return tuple(float(value) for value in values)  # type: ignore[return-value]


def format_number(value: float) -> str:
    return f"{value:.6f}".rstrip("0").rstrip(".")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument(
        "operation",
        nargs="+",
        type=parse_operation,
        metavar="OPERATION=FILE",
    )
    args = parser.parse_args()

    parsed: list[tuple[str, ET.Element]] = []
    boxes: list[tuple[float, float, float, float]] = []
    seen: set[str] = set()

    for operation, path in args.operation:
        if operation in seen:
            parser.error(f"operation supplied twice: {operation}")
        seen.add(operation)
        root = ET.parse(path).getroot()
        parsed.append((operation, root))
        boxes.append(view_box(root))

    min_x = min(box[0] for box in boxes)
    min_y = min(box[1] for box in boxes)
    max_x = max(box[0] + box[2] for box in boxes)
    max_y = max(box[1] + box[3] for box in boxes)
    width = max_x - min_x
    height = max_y - min_y

    output_root = ET.Element(
        f"{{{SVG_NS}}}svg",
        {
            "width": f"{format_number(width)}mm",
            "height": f"{format_number(height)}mm",
            "viewBox": " ".join(
                format_number(value)
                for value in (min_x, min_y, width, height)
            ),
            "version": "1.1",
        },
    )
    title = ET.SubElement(output_root, f"{{{SVG_NS}}}title")
    title.text = "OpenSCAD Cutter Lib operation export"

    for operation, source_root in parsed:
        group = ET.SubElement(
            output_root,
            f"{{{SVG_NS}}}g",
            {
                "id": operation,
                "data-operation": operation,
                "stroke": COLORS[operation],
                "fill": "none",
            },
        )
        for child in source_root:
            if child.tag == f"{{{SVG_NS}}}title":
                continue
            item = copy.deepcopy(child)
            item.attrib.pop("stroke", None)
            item.attrib.pop("fill", None)
            group.append(item)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    ET.ElementTree(output_root).write(
        args.output, encoding="utf-8", xml_declaration=True
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
