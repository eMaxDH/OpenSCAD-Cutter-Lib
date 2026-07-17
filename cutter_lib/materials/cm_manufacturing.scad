// Shared laser-cutting dimensions and compensation helpers.
//
// `kerf` is the full measured cut width. A laser follows the centre of an
// exported contour, so internal openings grow by approximately one kerf while
// external parts shrink by approximately one kerf.

function cut_compensation(kerf) =
    assert(kerf >= 0, "cut_compensation: kerf must be non-negative")
    kerf / 2;

// Drawn width for an internal slot whose finished width should accept the
// material plus the requested clearance.
function slot_width(material_thickness, fit_clearance=0, kerf=0) =
    assert(material_thickness > 0, "slot_width: material_thickness must be positive")
    assert(material_thickness + fit_clearance > kerf,
           "slot_width: kerf is too large for the requested finished slot")
    material_thickness + fit_clearance - kerf;

// Drawn width for an external tab. Positive fit_clearance makes the finished
// tab narrower relative to its matching slot.
function tab_width(material_thickness, fit_clearance=0, kerf=0) =
    assert(material_thickness > 0, "tab_width: material_thickness must be positive")
    assert(material_thickness - fit_clearance + kerf > 0,
           "tab_width: compensation produced a non-positive tab")
    material_thickness - fit_clearance + kerf;

// Compensate an arbitrary target dimension. `internal=true` describes a hole
// or pocket; false describes the outside of a cut part.
function compensated_dimension(target, kerf=0, internal=false) =
    assert(target > 0, "compensated_dimension: target must be positive")
    assert(kerf >= 0, "compensated_dimension: kerf must be non-negative")
    internal ? target - kerf : target + kerf;

function effective_pin_hole_diameter(pin_diameter, pin_clearance=0, kerf=0) =
    assert(pin_diameter > 0,
           "effective_pin_hole_diameter: pin_diameter must be positive")
    assert(pin_diameter + pin_clearance > kerf,
           "effective_pin_hole_diameter: requested hole is smaller than kerf")
    pin_diameter + pin_clearance - kerf;

