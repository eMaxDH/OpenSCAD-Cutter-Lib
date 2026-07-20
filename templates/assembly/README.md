# Assembly template

Copy this directory together with a renamed component template for a new
multi-part project. The example separates defaults, component definitions,
assembly placement, and deterministic sheet layout.

Replace all `tpl_` declarations and `TPL-` part IDs. Extend the output router
only with modes defined by `docs/CUSTOMIZER_STANDARD.md`. Keep separate SVG
exports authoritative even if a composite LightBurn convenience file is added.

Run `acceptance.sh` after adapting the template and register every non-`_2d`
entry file in `tests/public_files.txt`.
