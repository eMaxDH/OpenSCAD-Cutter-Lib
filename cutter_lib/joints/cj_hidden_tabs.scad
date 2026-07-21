use <../materials/cm_manufacturing.scad>

/* [Output] */
make_3d = true; // [false:true]

/* [Material] */
material_thickness = 4; // [1:0.1:10]
fit_clearance = 0.15;   // [0:0.05:1]
kerf = 0.15;            // [0:0.01:1]

/* [Example] */
example_size = [80, 35];
example_tab_count = 3; // [1:1:8]

/* [Hidden] */

if (make_3d)
    linear_extrude(height=material_thickness)
        cj_hidden_tabbed_panel_2d(
            size=example_size,
            tab_depth=material_thickness,
            count=example_tab_count,
            fit_clearance=fit_clearance,
            kerf=kerf);
else
    cj_hidden_tabbed_panel_2d(
        size=example_size,
        tab_depth=material_thickness,
        count=example_tab_count,
        fit_clearance=fit_clearance,
        kerf=kerf);

// Positions `count` equally spaced features along an edge. Children must be
// 2D geometry centred on their local X origin and extending in +Y.
module cj_edge_pattern(edge_length, count=3, edge_margin=4)
{
    assert(edge_length > 0, "cj_edge_pattern: edge_length must be positive");
    assert(count >= 1 && floor(count) == count,
           "cj_edge_pattern: count must be a positive integer");
    assert(edge_margin >= 0 && 2*edge_margin < edge_length,
           "cj_edge_pattern: edge margins consume the edge");

    pitch = (edge_length - 2*edge_margin) / count;
    assert(pitch > 0, "cj_edge_pattern: feature pitch must be positive");

    for (i = [0:count-1])
        translate([edge_margin + pitch*(i + 0.5), 0])
            children();
}

// Male tabs for a hidden internal edge. `feature_width` is the nominal width
// along the edge, while `tab_depth` is normally the material thickness.
module cj_hidden_tabs_2d(edge_length, tab_depth, feature_width,
                         count=3, edge_margin=4,
                         fit_clearance=0, kerf=0)
{
    drawn_width = tab_width(feature_width, fit_clearance, kerf);
    pitch = (edge_length - 2*edge_margin) / count;

    assert(tab_depth > 0, "cj_hidden_tabs_2d: tab_depth must be positive");
    assert(drawn_width < pitch,
           "cj_hidden_tabs_2d: tabs overlap; reduce width/count or margins");

    cj_edge_pattern(edge_length, count, edge_margin)
        translate([-drawn_width/2, 0])
            square([drawn_width, tab_depth]);
}

// Matching internal slots. Use in a difference() operation.
module cj_hidden_slots_2d(edge_length, material_thickness, feature_width,
                          count=3, edge_margin=4,
                          fit_clearance=0, kerf=0)
{
    drawn_length = slot_width(feature_width, fit_clearance, kerf);
    drawn_depth = slot_width(material_thickness, fit_clearance, kerf);
    pitch = (edge_length - 2*edge_margin) / count;

    assert(drawn_length < pitch,
           "cj_hidden_slots_2d: slots overlap; reduce width/count or margins");

    cj_edge_pattern(edge_length, count, edge_margin)
        translate([-drawn_length/2, -drawn_depth/2])
            square([drawn_length, drawn_depth]);
}

// Matching slots that open directly onto a panel edge. Children extend in
// +Y from that edge, like `cj_hidden_tabs_2d`. Only the closed inner end needs
// depth compensation; the open end is supplied by the panel perimeter cut.
module cj_hidden_edge_notches_2d(
    edge_length, material_thickness, feature_width,
    count=3, edge_margin=4,
    fit_clearance=0, kerf=0)
{
    drawn_length = slot_width(
        feature_width, fit_clearance, kerf);
    drawn_depth =
        material_thickness+fit_clearance-
        cut_compensation(kerf);
    pitch = (edge_length-2*edge_margin)/count;

    assert(drawn_depth > 0,
           "cj_hidden_edge_notches_2d: kerf consumes notch depth");
    assert(drawn_length < pitch,
           "cj_hidden_edge_notches_2d: notches overlap; reduce width/count or margins");

    cj_edge_pattern(edge_length, count, edge_margin)
        translate([-drawn_length/2, 0])
            square([drawn_length, drawn_depth]);
}

// Adds tabs to one edge of a rectangular panel. The edge may be "bottom",
// "top", "left", or "right". Tabs point away from the panel.
module cj_hidden_tabbed_panel_2d(size, edge="bottom",
                                 tab_depth=4, feature_width=8,
                                 count=3, edge_margin=4,
                                 fit_clearance=0, kerf=0)
{
    assert(size[0] > 0 && size[1] > 0,
           "cj_hidden_tabbed_panel_2d: panel size must be positive");
    assert(edge == "bottom" || edge == "top" ||
           edge == "left" || edge == "right",
           "cj_hidden_tabbed_panel_2d: unsupported edge");

    union() {
        square(size);

        if (edge == "bottom")
            mirror([0,1])
                cj_hidden_tabs_2d(size[0], tab_depth, feature_width,
                                  count, edge_margin, fit_clearance, kerf);
        else if (edge == "top")
            translate([0, size[1]])
                cj_hidden_tabs_2d(size[0], tab_depth, feature_width,
                                  count, edge_margin, fit_clearance, kerf);
        else if (edge == "left")
            rotate([0,0,90])
                cj_hidden_tabs_2d(size[1], tab_depth, feature_width,
                                  count, edge_margin, fit_clearance, kerf);
        else
            translate([size[0], 0])
                rotate([0,0,90])
                    mirror([0,1])
                        cj_hidden_tabs_2d(size[1], tab_depth, feature_width,
                                          count, edge_margin,
                                          fit_clearance, kerf);
    }
}
