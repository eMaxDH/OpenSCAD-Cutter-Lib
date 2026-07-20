#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
registry="$repo_root/tests/public_files.txt"
work_dir="${TMPDIR:-/tmp}/openscad-cutter-lib-governance"
mkdir -p "$work_dir"

find "$repo_root/cutter_lib" "$repo_root/project" "$repo_root/templates" \
    -type f -name '*.scad' ! -name '*_2d.scad' \
    | sed "s|$repo_root/||" | sort > "$work_dir/discovered.txt"
sort "$registry" > "$work_dir/registered.txt"

if ! cmp -s "$work_dir/discovered.txt" "$work_dir/registered.txt"; then
    echo "ERROR: tests/public_files.txt does not match governed entry files." >&2
    diff -u "$work_dir/registered.txt" "$work_dir/discovered.txt" || true
    exit 1
fi

required_docs=(
    LICENSE GOVERNANCE.md CONTRIBUTING.md CHANGELOG.md
    docs/ARCHITECTURE.md docs/DESIGN_STANDARD.md
    docs/CUSTOMIZER_STANDARD.md docs/MANUFACTURING_STANDARD.md
    docs/EXPORT_STANDARD.md docs/TESTING.md docs/API.md
)

for relative in "${required_docs[@]}"; do
    test -s "$repo_root/$relative" || {
        echo "ERROR: required documentation is missing: $relative" >&2
        exit 1
    }
done

while IFS= read -r relative; do
    file="$repo_root/$relative"
    grep -Eq '^make_3d[[:space:]]*=' "$file" || {
        echo "ERROR: $relative has no file-level make_3d control." >&2
        exit 1
    }
    grep -Fq '/* [Example] */' "$file" || {
        echo "ERROR: $relative has no [Example] Customizer section." >&2
        exit 1
    }
done < "$registry"

if rg -n '\bvisibile_layers\b|\belement_hight\b|cshape_array_arange_example' \
    "$repo_root/cutter_lib" "$repo_root/project" "$repo_root/templates" \
    -g '*.scad' -g '*.json'; then
    echo "ERROR: a removed pre-1.0 API spelling remains in source." >&2
    exit 1
fi

if rg -n 'include[[:space:]]*<' "$repo_root/cutter_lib" "$repo_root/templates"; then
    echo "ERROR: reusable library/template code must import with use, not include." >&2
    exit 1
fi

echo "Governance checks passed: $(wc -l < "$registry") entry files registered."
