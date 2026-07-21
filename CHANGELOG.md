# Changelog

All notable changes are recorded here. The project is currently preparing its
first stable public API and may make documented breaking changes before 1.0.

## Unreleased

### Added

- MIT license.
- Maintainer-led governance and contribution process.
- Repository-wide geometry, Customizer, manufacturing, export, and testing
  standards.
- Architecture Decision Record process.
- Component and assembly templates.
- Public entry-file registry and automated governance/render checks.
- GitHub Actions validation for OpenSCAD 2021.01.

### Changed

- Began standardising standalone examples and the `make_3d` interface.
- Corrected the breaking pre-1.0 API spellings `visibile_layers` to
  `visible_layers`, `element_hight` to `element_height`, and
  `cshape_array_arange_example` to `cshape_array_arrange_example`.
- Fixed element sizing when only `element_height` is supplied.
