# Testing

The test strategy combines inexpensive static governance checks with actual
OpenSCAD renders.

## Commands

```sh
tests/governance.sh
tests/render_examples.sh
tests/bob_acceptance.sh
```

`governance.sh` checks the declared entry-file inventory, required Customizer
controls, documentation, and forbidden generated artifacts. `render_examples.sh`
opens every governed entry file in both modes and checks for non-empty CSG/SVG
output. Project acceptance scripts exercise parameters, layouts, and regression
properties that generic rendering cannot prove.

Outputs are written below `${TMPDIR:-/tmp}`.

## CI policy

CI runs on pull requests and pushes to the main branch with OpenSCAD 2021.01.
The main branch should require the `governance` and `render` jobs. Test artifacts
may be uploaded for visual inspection but are not source files.

## Geometry limits

OpenSCAD cannot inspect arbitrary child bounds or prove solids collision-free.
Layouts therefore validate declared boxes, while project tests must cover
motion, fit, and profile-specific invariants. Visual inspection remains part of
review for high-risk assemblies.
