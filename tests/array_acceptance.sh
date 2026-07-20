#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="${TMPDIR:-/tmp}/openscad-cutter-lib-array-tests"
mkdir -p "$output_dir"

openscad -o "$output_dir/array-api.csg" "$repo_root/tests/array_api.scad"
test -s "$output_dir/array-api.csg"

echo "Array API checks passed. Output: $output_dir/array-api.csg"
