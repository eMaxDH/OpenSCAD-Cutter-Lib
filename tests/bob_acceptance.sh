#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
model="$repo_root/project/bob_dishwasher/bob_dishwasher.scad"
output_dir="${TMPDIR:-/tmp}/openscad-cutter-lib-bob-tests"

if ! command -v openscad >/dev/null 2>&1; then
    echo "ERROR: openscad is required for Bob acceptance renders." >&2
    exit 127
fi

mkdir -p "$output_dir"

for height in 70 80 100; do
    openscad \
        -o "$output_dir/bob-${height}mm.csg" \
        -D "model_height=$height" \
        -D 'output_mode="assembly"' \
        -D 'door_angle=45' \
        "$model"
done

for angle in 0 45 90; do
    openscad \
        -o "$output_dir/bob-door-${angle}deg.csg" \
        -D 'model_height=80' \
        -D 'output_mode="assembly"' \
        -D "door_angle=$angle" \
        "$model"
done

for kerf in 0.15 0.5; do
    openscad \
        -o "$output_dir/bob-layout-kerf-${kerf}.svg" \
        -D 'model_height=80' \
        -D 'output_mode="cut_layout"' \
        -D 'layout_material="all"' \
        -D "kerf=$kerf" \
        "$model"
done

openscad \
    -o "$output_dir/bob-layout-70mm.svg" \
    -D 'model_height=70' \
    -D 'output_mode="cut_layout"' \
    "$model"

openscad \
    -o "$output_dir/bob-layout-100mm.svg" \
    -D 'model_height=100' \
    -D 'output_mode="cut_layout"' \
    "$model"

openscad \
    -o "$output_dir/bob-calibration.svg" \
    -D 'output_mode="calibration"' \
    "$model"

openscad \
    -o "$output_dir/bob-veneer-cut.svg" \
    -D 'output_mode="cut_layout"' \
    -D 'layout_material="veneer"' \
    -D 'layout_operation="cut"' \
    "$model"

openscad \
    -o "$output_dir/bob-veneer-engrave.svg" \
    -D 'output_mode="cut_layout"' \
    -D 'layout_material="veneer"' \
    -D 'layout_operation="engrave"' \
    "$model"

echo "Bob acceptance renders passed. Outputs: $output_dir"
