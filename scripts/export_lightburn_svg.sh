#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 MODEL.scad OUTPUT_PREFIX [cut,engrave[,score]] [OPENSCAD_ARGS...]" >&2
}

if [[ $# -lt 2 ]]; then
    usage
    exit 2
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
model="$1"
prefix="$2"
operations="${3:-cut,engrave}"
if [[ $# -ge 3 ]]; then
    shift 3
else
    shift 2
fi

if ! command -v openscad >/dev/null 2>&1; then
    echo "ERROR: openscad is required." >&2
    exit 127
fi

mkdir -p "$(dirname "$prefix")"
merge_args=()
IFS=',' read -r -a requested <<< "$operations"

for operation in "${requested[@]}"; do
    case "$operation" in
        cut|engrave|score|reference) ;;
        *) echo "ERROR: unsupported operation: $operation" >&2; exit 2 ;;
    esac

    output="${prefix}_${operation}.svg"
    openscad -o "$output" \
        -D 'make_3d=false' \
        -D 'output_mode="cut_layout"' \
        -D "layout_operation=\"$operation\"" \
        "$@" "$model"
    test -s "$output"
    grep -q '<svg' "$output"
    merge_args+=("${operation}=${output}")
done

python3 "$repo_root/scripts/merge_operation_svgs.py" \
    --output "${prefix}_all.svg" "${merge_args[@]}"
for operation in "${requested[@]}"; do
    grep -q "data-operation=\"$operation\"" "${prefix}_all.svg" || {
        echo "ERROR: composite output contains no $operation operation." >&2
        exit 1
    }
done

echo "LightBurn SVG exports written to ${prefix}_{cut,...,all}.svg"
