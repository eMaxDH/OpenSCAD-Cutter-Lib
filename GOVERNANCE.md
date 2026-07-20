# Governance

OpenSCAD Cutter Lib is primarily maintained by the repository owner. The
maintainer has final authority over scope, technical direction, releases, and
the public API. Governance is intentionally lightweight; automated checks and
written design decisions provide consistency without a committee process.

## Project purpose

The project provides reusable OpenSCAD tools, connections, and design patterns
for laser-cut assemblies. A manufactured part is defined by one canonical 2D
profile, reused for its 3D preview and its flat cutting layout.

## Roles

- **Maintainer:** reviews and merges changes, resolves design questions,
  publishes releases, and declares supported APIs.
- **Contributor:** proposes changes through issues or pull requests and adds
  the documentation and tests required by this repository.

The maintainer may delegate work without transferring final release authority.

## Decisions

Small, reversible changes use normal pull-request review. A short Architecture
Decision Record (ADR) is required when a change:

- changes the canonical 2D/3D geometry contract;
- adds or changes an output operation or file format;
- breaks or substantially expands the public API;
- changes units, axes, kerf, clearance, or layer conventions; or
- introduces a new component family or repository-level dependency.

ADRs live in `docs/adr/`, state the context, decision, consequences, and
status, and are approved by the maintainer.

## Changes and review

Changes should normally be submitted as pull requests. A change is ready to
merge when:

1. its canonical profiles and public parameters are documented;
2. its 2D and 3D examples render with OpenSCAD 2021.01;
3. generated layouts contain the same manufactured profiles as the assembly;
4. applicable repository and project acceptance tests pass; and
5. public API or design decisions are recorded when required.

The main branch should be protected and require the repository CI workflow.

## Releases

Before version 1.0 the public API may be cleaned up, with changes recorded in
`docs/API_MIGRATION_V1.md` and `CHANGELOG.md`. Version 1.0 freezes the declared
public API in `tests/public_files.txt` and `docs/API.md`.

After version 1.0 the project follows semantic versioning:

- patch: compatible fixes and documentation;
- minor: compatible functionality and deprecations;
- major: incompatible public API or manufacturing-contract changes.

Deprecated APIs remain for at least one minor release unless retaining them
would generate incorrect manufacturing output.

## Security and fabrication safety

Geometry in this repository is a design aid, not a certification of structural,
electrical, fire, food-contact, or machine safety. Reports that could cause
unsafe fabrication should be handled before cosmetic or convenience changes.

## License authority

Only the repository owner may select or change the project license. A license
must be chosen before the 1.0 release; contributors must not infer a license
from source availability.
