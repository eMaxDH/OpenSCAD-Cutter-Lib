# Component template

Copy this directory when adding one reusable laser-cut component. Rename the
`tpl_` prefix, files, modules, parameters, and part IDs.

`component_2d.scad` owns the manufacturing outline. `component.scad` is the
public, directly renderable wrapper. Its 3D mode extrudes the same profile.

After copying, add the wrapper to `tests/public_files.txt`, document it in
`docs/API.md`, and run `tests/governance.sh` and `tests/render_examples.sh`.
