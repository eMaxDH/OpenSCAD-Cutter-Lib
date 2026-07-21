#!/usr/bin/env bash
set -euo pipefail

template_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
output_dir="${TMPDIR:-/tmp}/openscad-cutter-lib-template-tests"
mkdir -p "$output_dir"

openscad -o "$output_dir/assembly.csg" \
    -D 'output_mode="assembly"' "$template_dir/assembly.scad"
openscad -o "$output_dir/cut.svg" \
    -D 'output_mode="cut_layout"' \
    -D 'layout_operation="cut"' "$template_dir/assembly.scad"

test -s "$output_dir/assembly.csg"
grep -q '<svg' "$output_dir/cut.svg"
echo "Template acceptance renders passed. Outputs: $output_dir"
