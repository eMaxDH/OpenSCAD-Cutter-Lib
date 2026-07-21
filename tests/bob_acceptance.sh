#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
model="$repo_root/project/bob_dishwasher/bob_dishwasher.scad"
presets="$repo_root/project/bob_dishwasher/bob_dishwasher.json"
output_dir="${TMPDIR:-/tmp}/openscad-cutter-lib-bob-tests"

if ! command -v openscad >/dev/null 2>&1; then
    echo "ERROR: openscad is required for Bob acceptance renders." >&2
    exit 127
fi

mkdir -p "$output_dir"

for component in bob_config bob_body bob_door bob_chamber bob_rack bob_layout; do
    openscad \
        -o "$output_dir/${component}-standalone-3d.csg" \
        -D 'make_3d=true' \
        "$repo_root/project/bob_dishwasher/${component}.scad"

    if [[ "$component" != "bob_config" ]]; then
        openscad \
            -o "$output_dir/${component}-standalone-2d.svg" \
            -D 'make_3d=false' \
            "$repo_root/project/bob_dishwasher/${component}.scad"
    fi
done

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

# Veneer thickness changes the plywood support envelope: the ribs and door
# must stop at the skin's inner face instead of sharing its exterior plane.
for veneer in 0.2 1.0; do
    openscad \
        -o "$output_dir/bob-rib-veneer-${veneer}mm.svg" \
        -D 'output_mode="single_part"' \
        -D 'single_part_id="BOB-RIB-01"' \
        -D "veneer_thickness=$veneer" \
        "$model"

    openscad \
        -o "$output_dir/bob-closed-veneer-${veneer}mm.csg" \
        -D 'output_mode="assembly"' \
        -D 'door_angle=0' \
        -D "veneer_thickness=$veneer" \
        "$model"
done

if cmp -s \
    "$output_dir/bob-rib-veneer-0.2mm.svg" \
    "$output_dir/bob-rib-veneer-1.0mm.svg"; then
    echo "ERROR: plywood ribs ignore veneer_thickness." >&2
    exit 1
fi

# Chamber clearance must affect both the assembly and its plywood sheet.
for gap in 0 1.0; do
    openscad \
        -o "$output_dir/bob-chamber-gap-${gap}mm.csg" \
        -D 'output_mode="assembly"' \
        -D "chamber_skeleton_gap=$gap" \
        "$model"

    openscad \
        -o "$output_dir/bob-chamber-gap-${gap}mm.svg" \
        -D 'output_mode="cut_layout"' \
        -D 'layout_material="plywood_2"' \
        -D 'layout_operation="cut"' \
        -D "chamber_skeleton_gap=$gap" \
        "$model"
done

if cmp -s \
    "$output_dir/bob-chamber-gap-0mm.svg" \
    "$output_dir/bob-chamber-gap-1.0mm.svg"; then
    echo "ERROR: plywood layout ignores chamber_skeleton_gap." >&2
    exit 1
fi

# Base-to-rib clearance must alter the canonical base cut profile. The same
# profile is extruded in the assembly, so its notches stay synchronized with
# the laser layout.
for spacing in 0 0.6; do
    openscad \
        -o "$output_dir/bob-base-rib-spacing-${spacing}mm.svg" \
        -D 'output_mode="cut_layout"' \
        -D 'layout_material="plywood_1"' \
        -D 'layout_operation="cut"' \
        -D "base_rib_spacing=$spacing" \
        "$model"
done

if cmp -s \
    "$output_dir/bob-base-rib-spacing-0mm.svg" \
    "$output_dir/bob-base-rib-spacing-0.6mm.svg"; then
    echo "ERROR: plywood base ignores base_rib_spacing." >&2
    exit 1
fi

# Saved presets must not override live Customizer door-angle changes.
for angle in 30 90; do
    openscad \
        -o "$output_dir/bob-preset-door-${angle}deg.csg" \
        -p "$presets" \
        -P "Default 80 mm assembly" \
        -D "door_angle=$angle" \
        "$model"
done

if cmp -s \
    "$output_dir/bob-preset-door-30deg.csg" \
    "$output_dir/bob-preset-door-90deg.csg"; then
    echo "ERROR: saved preset overrides door_angle." >&2
    exit 1
fi

# Verify that the three cradle-clearance controls can differ without breaking
# either the assembly placement or the generated manufacturing profiles.
openscad \
    -o "$output_dir/bob-cradle-asymmetric-gaps.csg" \
    -D 'output_mode="assembly"' \
    -D 'door_angle=45' \
    -D 'cradle_side_gap=0.8' \
    -D 'cradle_top_gap=1.2' \
    -D 'cradle_bottom_gap=0.2' \
    "$model"

openscad \
    -o "$output_dir/bob-layout-asymmetric-cradle-gaps.svg" \
    -D 'output_mode="cut_layout"' \
    -D 'layout_operation="cut"' \
    -D 'cradle_side_gap=0.8' \
    -D 'cradle_top_gap=1.2' \
    -D 'cradle_bottom_gap=0.2' \
    "$model"

# Both hinge-axis sliders must change the generated assembly.
for offsets in "0 0" "1.0 0.4"; do
    read -r vertical front_back <<< "$offsets"
    openscad \
        -o "$output_dir/bob-pin-offsets-${vertical}-${front_back}.csg" \
        -D 'output_mode="assembly"' \
        -D 'door_angle=30' \
        -D "hinge_pin_vertical_offset=$vertical" \
        -D "hinge_pin_front_back_offset=$front_back" \
        "$model"
done

if cmp -s \
    "$output_dir/bob-pin-offsets-0-0.csg" \
    "$output_dir/bob-pin-offsets-1.0-0.4.csg"; then
    echo "ERROR: hinge pin offset sliders do not change the assembly." >&2
    exit 1
fi

for kerf in 0.15 0.5; do
    openscad \
        -o "$output_dir/bob-layout-kerf-${kerf}.svg" \
        -D 'model_height=80' \
        -D 'output_mode="cut_layout"' \
        -D 'layout_material="all"' \
        -D 'layout_operation="cut"' \
        -D "kerf=$kerf" \
        "$model"
done

openscad \
    -o "$output_dir/bob-layout-70mm.svg" \
    -D 'model_height=70' \
    -D 'output_mode="cut_layout"' \
    -D 'layout_operation="cut"' \
    "$model"

openscad \
    -o "$output_dir/bob-layout-100mm.svg" \
    -D 'model_height=100' \
    -D 'output_mode="cut_layout"' \
    -D 'layout_operation="cut"' \
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

openscad \
    -o "$output_dir/bob-plywood-2-engrave.svg" \
    -D 'output_mode="cut_layout"' \
    -D 'layout_material="plywood_2"' \
    -D 'layout_operation="engrave"' \
    "$model"

for svg in "$output_dir"/*.svg; do
    test -s "$svg"
    grep -q '<svg' "$svg"
done

echo "Bob acceptance renders passed. Outputs: $output_dir"
