#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
registry="$repo_root/tests/public_files.txt"
output_dir="${TMPDIR:-/tmp}/openscad-cutter-lib-example-renders"
mkdir -p "$output_dir"

if ! command -v openscad >/dev/null 2>&1; then
    echo "ERROR: openscad is required." >&2
    exit 127
fi

version="$(openscad --version 2>&1)"
case "$version" in
    *2021.01*) ;;
    *) echo "ERROR: expected OpenSCAD 2021.01, found: $version" >&2; exit 1 ;;
esac

while IFS= read -r relative; do
    stem="${relative//\//__}"
    stem="${stem%.scad}"

    openscad -o "$output_dir/${stem}-3d.csg" \
        -D 'make_3d=true' "$repo_root/$relative"
    openscad -o "$output_dir/${stem}-2d.svg" \
        -D 'make_3d=false' "$repo_root/$relative"

    test -s "$output_dir/${stem}-3d.csg"
    grep -q '<svg' "$output_dir/${stem}-2d.svg"
done < "$registry"

echo "Standalone example renders passed. Outputs: $output_dir"
