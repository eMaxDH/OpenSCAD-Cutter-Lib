#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="${TMPDIR:-/tmp}/openscad-cutter-lib-export-tests"
prefix="$output_dir/bob_veneer"
mkdir -p "$output_dir"

"$repo_root/scripts/export_lightburn_svg.sh" \
    "$repo_root/project/bob_dishwasher/bob_dishwasher.scad" \
    "$prefix" cut,engrave \
    -D 'layout_material="veneer"'

for output in "${prefix}_cut.svg" "${prefix}_engrave.svg" \
              "${prefix}_all.svg"; do
    test -s "$output"
    grep -q '<svg' "$output"
done

grep -q 'stroke="#ff0000"' "${prefix}_all.svg"
grep -q 'stroke="#0000ff"' "${prefix}_all.svg"
echo "SVG operation export checks passed. Outputs: $output_dir"
