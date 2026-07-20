#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lamp_dir="$repo_root/project/lamp"
output_dir="${TMPDIR:-/tmp}/openscad-cutter-lib-lamp-tests"
mkdir -p "$output_dir"

openscad -o "$output_dir/lamp-preset.svg" \
    -p "$lamp_dir/lamp.json" -P "New set 1" \
    "$lamp_dir/lamp.scad"
openscad -o "$output_dir/lamp-floor-preset.svg" \
    -p "$lamp_dir/lamp_floor.json" -P "New set 1" \
    "$lamp_dir/lamp_floor.scad"

for output in "$output_dir"/*.svg; do
    test -s "$output"
    grep -q '<svg' "$output"
done

echo "Lamp preset checks passed. Outputs: $output_dir"
