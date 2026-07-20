use <../../cutter_lib/layout/cl_cut_layout.scad>
use <../../cutter_lib/calibration/ccal_laser_coupon.scad>
use <../../cutter_lib/shells/csh_ribbed_veneer.scad>
use <../../cutter_lib/trays/ctr_removable_tray.scad>
use <bob_body.scad>
use <bob_door.scad>
use <bob_chamber.scad>
use <bob_rack.scad>

/* [Example] */

make_3d = false; // [false:true]
example_model_height = 80; // [70:1:100]
example_sheet = "all"; // [all, plywood_1, plywood_2, veneer]
example_operation = "preview"; // [cut, engrave, preview]

/* [Hidden] */

example_model_width = 340 * example_model_height / 490;
example_model_depth = example_model_height;

if (make_3d)
    linear_extrude(0.6)
        bob_cut_layout(
            example_model_width,
            example_model_height,
            example_model_depth,
            material=example_sheet,
            operation=example_operation);
else
    bob_cut_layout(
        example_model_width,
        example_model_height,
        example_model_depth,
        material=example_sheet,
        operation=example_operation);

module bob_part_label(id, position=[1,1], size=1.8)
{
    %translate(position) {
        text(id, size=size);
        translate([0, size+0.8])
            polygon([[0,0], [3,0.8], [0,1.6]]);
    }
}

module bob_layout_layer_info(material="all", operation="preview",
                             sheet_size=[300,300], rib_count=4)
{
    logical_ribs = rib_count+2;
    rib_segments = 4*logical_ribs;

    echo(str("[BOB 2D LAYERS] material=", material,
             ", operation=", operation));
    echo("[BOB 2D LAYERS] plywood cut | plywood engraving | veneer cut | veneer engraving");
    echo(str("[BOB PART MANIFEST] plywood=", 18+rib_segments,
             " cut parts (including ", logical_ribs,
             " logical ribs / ", rib_segments,
             " glued rib segments and coupon), veneer=5 cut parts, purchased hinge pin=1"));

    %translate([0, sheet_size[1]+7]) {
        color("black")
            text(str("BOB 2D layout: material=", material,
                     "  operation=", operation), size=4);
        color("red")
            translate([0, -6])
                text("RED = cut geometry", size=3);
        color("blue")
            translate([55, -6])
                text("BLUE = engraving geometry", size=3);
        color("gray")
            translate([130, -6])
                text("GRAY = reference only", size=3);
    }
}

module bob_plywood_sheet_1(model_width, model_height, model_depth,
                           plywood_thickness=4,
                           veneer_thickness=0.6,
                           kerf=0.5, fit_clearance=0.15,
                           rib_count=4,
                           corner_radius=8,
                           cradle_side_gap=0.6,
                           cradle_bottom_gap=1.0,
                           cradle_top_gap=0.5,
                           sheet_size=[300,300],
                           margin=5, spacing=3,
                           base_rib_spacing=0.2,
                           front_offset=4,
                           rear_offset=4)
{
    total_ribs = rib_count+2;
    structural_width =
        bob_structural_width(model_width, veneer_thickness);
    structural_height =
        bob_structural_height(model_height, veneer_thickness);
    structural_radius =
        bob_structural_corner_radius(
            corner_radius, veneer_thickness);
    rib_stringer_positions =
        bob_stringer_x_positions(
            structural_width, plywood_thickness);
    stringer_rib_positions =
        bob_all_rib_positions(
            model_depth, plywood_thickness,
            veneer_thickness, rib_count,
            front_offset, rear_offset);
    hinge_corner_radius =
        bob_hinge_cradle_inner_radius(
            corner_radius,
            plywood_thickness,
            veneer_thickness);
    cradle_height = bob_hinge_cradle_height(
        plywood_thickness,
        veneer_thickness,
        cradle_bottom_gap,
        cradle_top_gap,
        hinge_corner_radius);
    assert(rib_count >= 1,
           "bob_plywood_sheet_1: at least one internal rib is required");

    dw = bob_door_width(model_width);
    dh = bob_door_height(
        model_height, plywood_thickness,
        veneer_thickness,
        cradle_bottom_gap);
    tongue_width = bob_door_tongue_width(
        model_width, plywood_thickness,
        veneer_thickness, cradle_side_gap);
    base = [
        bob_base_width(
            structural_width, plywood_thickness),
        model_depth-veneer_thickness-2*plywood_thickness
    ];
    base_rib_positions = bob_base_rib_positions(
        model_depth, plywood_thickness,
        veneer_thickness, rib_count,
        front_offset, rear_offset);
    base_bridge = [
        bob_base_front_bridge_width(
            model_width,
            corner_radius),
        bob_base_front_bridge_depth(
            plywood_thickness)
    ];
    cap_piece_h = bob_rib_cap_piece_height(
        structural_radius, plywood_thickness);
    side_length = bob_rib_side_length(
        structural_height, structural_radius,
        plywood_thickness);
    cap_columns = 4;
    cap_rows = ceil(2*total_ribs/cap_columns);
    cap_boxes = [
        for (i = [0:2*total_ribs-1])
            [
                margin+(i%cap_columns)*(structural_width+spacing),
                margin+floor(i/cap_columns)*(cap_piece_h+spacing),
                structural_width, cap_piece_h
            ]
    ];

    parts_y = margin+cap_rows*cap_piece_h+
              cap_rows*spacing;
    side_boxes = [
        for (i = [0:2*total_ribs-1])
            [
                margin+i*(plywood_thickness+spacing),
                parts_y,
                plywood_thickness, side_length
            ]
    ];
    side_band_width =
        2*total_ribs*plywood_thickness+
        (2*total_ribs-1)*spacing;
    door_x = margin+side_band_width+spacing;
    base_x = door_x+dw+spacing;
    base_bridge_y =
        parts_y+base[1]+spacing;
    cage_x = base_x+base[0]+spacing;
    cage_width = 2*plywood_thickness+spacing;
    cradle_x = base_x;
    cradle_y = base_bridge_y+base_bridge[1]+spacing;
    cradle = [
        structural_width,
        cradle_height-veneer_thickness
    ];
    stringer_length =
        model_depth-veneer_thickness;

    boxes = concat(cap_boxes, side_boxes, [
        [door_x, parts_y, dw, dh],
        [base_x, parts_y, base[0], base[1]],
        [base_x, base_bridge_y,
         base_bridge[0], base_bridge[1]],
        [cage_x, parts_y, cage_width,
         stringer_length],
        [cradle_x, cradle_y,
         cradle[0], cradle[1]]
    ]);

    cl_validate_layout(
        boxes, sheet_size, margin, spacing,
        "BOB plywood sheet 1");
    cl_sheet_boundary(sheet_size, "BOB plywood 4 mm - sheet 1");

    old_rib_box_area =
        total_ribs*structural_width*structural_height;
    segmented_rib_box_area =
        total_ribs*(
            2*structural_width*cap_piece_h+
            2*plywood_thickness*side_length);
    echo(str(
        "[BOB RIB NESTING] allocated rib footprint ",
        old_rib_box_area, " -> ", segmented_rib_box_area,
        " mm^2 (",
        100*(old_rib_box_area-segmented_rib_box_area)/
            old_rib_box_area,
        "% reduction)"));

    rib_ids = concat(
        ["BOB-FRONT-FRAME"],
        [
            for (i = [1:rib_count])
                str("BOB-RIB-", i < 10 ? "0" : "", i)
        ],
        ["BOB-REAR-FRAME"]);

    // Each logical rib is split on its straight vertical runs, immediately
    // beside the rounded corners. Broad complementary 45-degree faces carry
    // the glue; the library connector's small step only aligns the pieces.
    for (i = [0:2*total_ribs-1]) {
        rib_index = floor(i/2);
        top = i%2 == 1;
        segment_id = str(
            rib_ids[rib_index],
            top ? "-TOP" : "-BOTTOM");
        cl_layout_part(
            [cap_boxes[i][0], cap_boxes[i][1]],
            [structural_width, cap_piece_h],
            segment_id,
            sheet_size=sheet_size, margin=margin) {
                bob_rib_cap_2d(
                    structural_width, structural_height,
                    plywood_thickness, structural_radius,
                    top, fit_clearance, kerf,
                    rib_stringer_positions);
                bob_part_label(
                    segment_id,
                    [plywood_thickness+1,
                     plywood_thickness+1]);
            }
    }

    for (i = [0:2*total_ribs-1]) {
        rib_index = floor(i/2);
        side = i%2 == 0 ? "LEFT" : "RIGHT";
        segment_id = str(rib_ids[rib_index], "-", side);
        cl_layout_part(
            [side_boxes[i][0], side_boxes[i][1]],
            [plywood_thickness, side_length],
            segment_id,
            sheet_size=sheet_size, margin=margin)
                bob_rib_side_2d(
                    structural_height, plywood_thickness,
                    structural_radius, fit_clearance, kerf);
    }

    cl_layout_part(
        [door_x, parts_y], [dw, dh],
        "BOB-DOOR-FRAME",
        sheet_size=sheet_size, margin=margin) {
            bob_door_frame_2d(
                dw, dh,
                max(5, plywood_thickness),
                corner_radius,
                plywood_thickness=plywood_thickness,
                tongue_width=tongue_width,
                tongue_corner_radius=
                    hinge_corner_radius);
            bob_part_label("BOB-DOOR-FRAME");
        }

    cl_layout_part(
        [base_x, parts_y], base,
        "BOB-BASE",
        sheet_size=sheet_size, margin=margin) {
            bob_base_2d(
                structural_width,
                model_depth-veneer_thickness,
                plywood_thickness,
                base_rib_positions,
                base_rib_spacing,
                structural_radius,
                bob_base_side_inset(
                    plywood_thickness));
            bob_part_label("BOB-BASE");
        }

    cl_layout_part(
        [base_x, base_bridge_y],
        base_bridge,
        "BOB-BASE-FRONT-BRIDGE",
        sheet_size=sheet_size, margin=margin) {
            bob_base_front_bridge_2d(
                model_width,
                corner_radius,
                plywood_thickness);
            bob_part_label(
                "BOB-BASE-FRONT-BRIDGE",
                [1,1], 1.4);
        }

    // Two upper stringers reach the front face of the front rib; the base
    // replaces the redundant lower pair as longitudinal structure.
    for (i = [0:1])
        translate([cage_x+i*(plywood_thickness+spacing), parts_y])
            bob_stringer_2d(
                stringer_length, plywood_thickness,
                stringer_rib_positions,
                fit_clearance);
    bob_part_label("BOB-STRINGER x2", [cage_x, parts_y+1]);

    cl_layout_part(
        [cradle_x, cradle_y], cradle,
        "BOB-HINGE-CRADLE",
        sheet_size=sheet_size, margin=margin) {
            bob_hinge_cradle_2d(
                structural_width,
                structural_height,
                plywood_thickness,
                structural_radius,
                cradle_height-veneer_thickness);
            bob_part_label("BOB-HINGE-CRADLE");
        }
}

module bob_plywood_sheet_2(model_width, model_height, model_depth,
                           plywood_thickness=4,
                           kerf=0.5, fit_clearance=0.15,
                           pin_diameter=2,
                           sheet_size=[300,300],
                           margin=5, spacing=3,
                           veneer_thickness=0.6,
                           chamber_skeleton_gap=0.5)
{
    cw = bob_chamber_width(
        model_width, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap);
    ch = bob_chamber_height(
        model_height, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap);
    cd = bob_chamber_depth(
        model_depth, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap);
    rear_width = bob_chamber_rear_width(
        cw, plywood_thickness);
    rack = bob_rack_size(
        model_width, model_depth, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap);
    // Open-edge chamber notches need a visible, robust nesting channel.
    // Ordinary part spacing makes their cutouts appear to merge with tabs
    // and labels on adjacent parts in OpenSCAD's filled 2D preview.
    chamber_layout_gap = max(
        spacing, 2*plywood_thickness);
    row1_h = max(ch, cd);
    row2_y = margin+row1_h+chamber_layout_gap;
    row3_y = row2_y+ch+chamber_layout_gap;
    runner_cut_width = 2*plywood_thickness+spacing;
    rail_width = plywood_thickness/2;
    rack_corner_radius = bob_rack_corner_radius();
    side_rail_length = bob_rack_side_rail_length(
        rack[1], rack_corner_radius, rail_width);
    back_rail_length = bob_rack_back_rail_length(rack[0]);
    rail_cut_width = 3*rail_width+2*spacing;
    runner_region = [
        runner_cut_width+spacing+rail_cut_width,
        cd
    ];

    floor_bound = [cw+2*plywood_thickness, cd];
    boxes = [
        [margin, margin, rear_width, ch],
        [margin+rear_width+spacing,
         margin, floor_bound[0], floor_bound[1]],
        [margin+rear_width+spacing+floor_bound[0]+spacing,
         margin, floor_bound[0], floor_bound[1]],
        [margin, row2_y, cd, ch],
        [margin+cd+chamber_layout_gap, row2_y, cd, ch],
        [margin, row3_y, rack[0], rack[1]],
        [margin+rack[0]+spacing, row3_y,
         runner_region[0], runner_region[1]],
        [margin+rack[0]+2*spacing+runner_region[0],
         row3_y, 85, 42]
    ];

    cl_validate_layout(
        boxes, sheet_size, margin, spacing,
        "BOB plywood sheet 2");
    cl_sheet_boundary(sheet_size, "BOB plywood 4 mm - sheet 2");

    cl_layout_part(
        [margin,margin], [rear_width,ch], "BOB-CHAMBER-REAR",
        sheet_size=sheet_size, margin=margin)
        bob_chamber_rear_2d(rear_width, ch);

    cl_layout_part(
        [margin+rear_width+spacing,margin], floor_bound,
        "BOB-CHAMBER-FLOOR",
        sheet_size=sheet_size, margin=margin)
        translate([plywood_thickness,0])
            bob_chamber_floor_2d(
                cw, cd, plywood_thickness,
                fit_clearance, kerf);

    cl_layout_part(
        [margin+rear_width+spacing+floor_bound[0]+spacing,
         margin], floor_bound,
        "BOB-CHAMBER-TOP",
        sheet_size=sheet_size, margin=margin)
        translate([plywood_thickness,0])
            bob_chamber_floor_2d(
                cw, cd, plywood_thickness,
                fit_clearance, kerf);

    cl_layout_part(
        [margin,row2_y], [cd,ch], "BOB-CHAMBER-SIDE-L",
        sheet_size=sheet_size, margin=margin)
        bob_chamber_side_2d(
            cd, ch, plywood_thickness,
            fit_clearance, kerf);

    cl_layout_part(
        [margin+cd+chamber_layout_gap,row2_y], [cd,ch],
        "BOB-CHAMBER-SIDE-R",
        sheet_size=sheet_size, margin=margin)
        bob_chamber_side_2d(
            cd, ch, plywood_thickness,
            fit_clearance, kerf);

    cl_layout_part(
        [margin,row3_y], rack, "BOB-RACK-BASE",
        sheet_size=sheet_size, margin=margin)
        bob_rack_base_2d(
            rack,
            corner_radius=rack_corner_radius,
            grip_width=min(14, rack[0]/2),
            grip_depth=4,
            dish_slots=4,
            dish_slot_width=2);

    // Tray runners / side rails.
    for (i = [0:1])
        translate([margin+rack[0]+spacing+
                   i*(plywood_thickness+spacing),
                   row3_y])
            translate([plywood_thickness, 0])
                rotate([0,0,90])
                    tray_runner(
                        cd,
                        width=plywood_thickness,
                        height=plywood_thickness/2,
                        stop_height=plywood_thickness/2,
                        make_3d=false);
    bob_part_label(
        "BOB-TRAY-RUNNER x2",
        [margin+rack[0]+spacing, row3_y+1]);

    // Two low side rails belonging to the removable rack itself.
    for (i = [0:1])
        translate([
            margin+rack[0]+spacing+
            runner_cut_width+spacing+
            i*(rail_width+spacing),
            row3_y])
            bob_rack_side_rail_2d(
                side_rail_length,
                plywood_thickness);
    bob_part_label(
        "BOB-RACK-SIDE-RAIL x2",
        [margin+rack[0]+spacing+
         runner_cut_width+spacing, row3_y+1]);

    // Rear rail, rotated so all three rack rails share a narrow layout band.
    translate([
        margin+rack[0]+spacing+
        runner_cut_width+spacing+
        2*(rail_width+spacing)+rail_width,
        row3_y
    ])
        rotate([0,0,90])
            bob_rack_back_rail_2d(
                back_rail_length,
                plywood_thickness);
    bob_part_label(
        "BOB-RACK-BACK-RAIL",
        [margin+rack[0]+spacing+
         runner_cut_width+spacing+
         2*(rail_width+spacing), row3_y+1]);

    cl_layout_part(
        [margin+rack[0]+2*spacing+runner_region[0],
         row3_y],
        [85,42], "BOB-CAL-01",
        sheet_size=sheet_size, margin=margin)
        ccal_laser_coupon(
            plywood_thickness, kerf, pin_diameter);
}

// Engraving geometry is kept at exactly the same sheet coordinates as its
// matching cut part so cut and engrave SVG exports can be overlaid.
module bob_plywood_sheet_2_engraving(
    model_width, model_height, model_depth,
    plywood_thickness=4,
    sheet_size=[300,300],
    margin=5, spacing=3,
    veneer_thickness=0.6,
    chamber_skeleton_gap=0.5)
{
    cw = bob_chamber_width(
        model_width, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap);
    cd = bob_chamber_depth(
        model_depth, plywood_thickness,
        veneer_thickness, chamber_skeleton_gap);
    floor_x = margin+cw+spacing;

    translate([
        floor_x+plywood_thickness+cw/2,
        margin+cd*0.55])
        bob_chamber_spray_arm_2d(cw);
}

module bob_veneer_sheet(model_width, model_height, model_depth,
                        plywood_thickness=4,
                        veneer_thickness=0.6,
                        cradle_side_gap=0.6,
                        cradle_bottom_gap=1.0,
                        cradle_top_gap=0.5,
                        corner_radius=8,
                        front_offset=4,
                        rear_offset=4,
                        sheet_size=[300,300],
                        margin=5, spacing=3,
                        window_mode="open",
                        operation="cut")
{
    wrap = csh_wrap_length(
        model_width, model_height, corner_radius);
    // Match the assembled wrap: cover the front rib completely and meet the
    // inner face of the rear veneer without overlapping that face sheet.
    skin_depth = model_depth-veneer_thickness;
    dw = bob_door_width(model_width);
    door_bottom = bob_door_bottom(
        plywood_thickness, veneer_thickness,
        cradle_bottom_gap);
    dh = bob_door_height(
        model_height, plywood_thickness,
        veneer_thickness,
        cradle_bottom_gap);
    hinge_corner_radius =
        bob_hinge_cradle_inner_radius(
            corner_radius,
            plywood_thickness,
            veneer_thickness);
    cradle_height = bob_hinge_cradle_height(
        plywood_thickness,
        veneer_thickness,
        cradle_bottom_gap,
        cradle_top_gap,
        hinge_corner_radius);
    tongue_width = bob_door_tongue_width(
        model_width, plywood_thickness,
        veneer_thickness, cradle_side_gap);
    cradle_profile = [
        model_width,
        cradle_height
    ];
    cradle_edge_strip = [
        bob_hinge_cradle_outer_edge_length(
            model_width,
            corner_radius,
            cradle_height),
        plywood_thickness
    ];
    row2_y = margin+skin_depth+spacing;
    cradle_x = margin+dw+spacing;
    rear_x =
        cradle_x+cradle_profile[0]+spacing;
    edge_y =
        row2_y+max(dh, model_height)+spacing;

    boxes = [
        [margin, margin, wrap, skin_depth],
        [margin, row2_y, dw, dh],
        [cradle_x, row2_y,
         cradle_profile[0], cradle_profile[1]],
        [rear_x, row2_y,
         model_width, model_height],
        [margin, edge_y,
         cradle_edge_strip[0],
         cradle_edge_strip[1]]
    ];

    cl_validate_layout(
        boxes, sheet_size, margin, spacing,
        "BOB veneer sheet");
    cl_sheet_boundary(sheet_size, "BOB veneer 0.6 mm");

    if (operation != "engrave")
    cl_layout_part(
        [margin,margin], [wrap,skin_depth],
        "BOB-VENEER-WRAP",
        sheet_size=sheet_size, margin=margin)
        cl_operation_geometry("cut", operation)
            veneer_skin_layout(
                model_width, model_height, model_depth,
                corner_radius, 0, veneer_thickness);

    cl_layout_part(
        [margin,row2_y], [dw,dh],
        "BOB-DOOR-FASCIA",
        sheet_size=sheet_size, margin=margin)
        {
            cl_operation_geometry("cut", operation)
                bob_door_trimmed_fascia_2d(
                    dw, dh,
                    plywood_thickness,
                    veneer_thickness,
                    corner_radius,
                    window_mode,
                    tongue_width,
                    hinge_corner_radius,
                    corner_radius,
                    cradle_height,
                    door_bottom);
            cl_operation_geometry("engrave", operation)
            bob_door_engraving_2d(dw, dh);
        }

    if (operation != "engrave")
    cl_layout_part(
        [cradle_x,row2_y],
        cradle_profile,
        "BOB-HINGE-CRADLE-VENEER",
        sheet_size=sheet_size, margin=margin)
        cl_operation_geometry("cut", operation)
            bob_hinge_cradle_finished_2d(
                model_width,
                model_height,
                plywood_thickness,
                veneer_thickness,
                corner_radius,
                cradle_height);

    if (operation != "engrave")
    cl_layout_part(
        [margin,edge_y],
        cradle_edge_strip,
        "BOB-HINGE-CRADLE-EDGE-VENEER",
        sheet_size=sheet_size, margin=margin)
        cl_operation_geometry("cut", operation)
            bob_hinge_cradle_edge_strip_2d(
                model_width,
                plywood_thickness,
                corner_radius,
                cradle_height);

    if (operation != "engrave")
    cl_layout_part(
        [rear_x,row2_y],
        [model_width,model_height],
        "BOB-REAR-VENEER",
        sheet_size=sheet_size, margin=margin)
        cl_operation_geometry("cut", operation)
            csh_rounded_rect_2d(
                [model_width,model_height], corner_radius);
}

module bob_cut_layout(model_width, model_height, model_depth,
                      plywood_thickness=4,
                      veneer_thickness=0.6,
                      kerf=0.5, fit_clearance=0.15,
                      rib_count=4,
                      corner_radius=8,
                      front_offset=4,
                      rear_offset=4,
                      pin_diameter=2,
                      pin_clearance=0.2,
                      cradle_side_gap=0.6,
                      cradle_bottom_gap=1.0,
                      cradle_top_gap=0.5,
                      chamber_skeleton_gap=0.5,
                      sheet_size=[300,300],
                      margin=5, spacing=3,
                      window_mode="open",
                      material="all",
                      operation="cut",
                      base_rib_spacing=0.2)
{
    sheet_gap = 20;
    assert(material == "all" ||
           material == "plywood_1" ||
           material == "plywood_2" ||
           material == "veneer",
           "bob_cut_layout: unsupported material selection");
    assert(operation == "cut" ||
           operation == "engrave" ||
           operation == "preview",
           "bob_cut_layout: unsupported operation");
    bob_layout_layer_info(material, operation, sheet_size, rib_count);

    if (material == "all" || material == "plywood_1")
    translate(material == "all" ? [0,0] : [0,0])
    cl_operation_geometry("cut", operation)
    bob_plywood_sheet_1(
        model_width, model_height, model_depth,
        plywood_thickness, veneer_thickness,
        kerf, fit_clearance,
        rib_count, corner_radius,
        cradle_side_gap,
        cradle_bottom_gap,
        cradle_top_gap,
        sheet_size, margin, spacing,
        base_rib_spacing,
        front_offset, rear_offset);

    if (material == "all" || material == "plywood_2")
    translate(material == "all"
              ? [sheet_size[0]+sheet_gap,0]
              : [0,0])
        cl_operation_geometry("cut", operation)
        bob_plywood_sheet_2(
            model_width, model_height, model_depth,
            plywood_thickness, kerf, fit_clearance,
            pin_diameter,
            sheet_size, margin, spacing,
            veneer_thickness,
            chamber_skeleton_gap);

    if (material == "all" || material == "plywood_2")
    translate(material == "all"
              ? [sheet_size[0]+sheet_gap,0]
              : [0,0])
        cl_operation_geometry("engrave", operation)
        bob_plywood_sheet_2_engraving(
            model_width, model_height, model_depth,
            plywood_thickness,
            sheet_size, margin, spacing,
            veneer_thickness,
            chamber_skeleton_gap);

    if (material == "all" || material == "veneer")
    translate(material == "all"
              ? [2*(sheet_size[0]+sheet_gap),0]
              : [0,0])
        bob_veneer_sheet(
            model_width, model_height, model_depth,
            plywood_thickness, veneer_thickness,
            cradle_side_gap,
            cradle_bottom_gap,
            cradle_top_gap,
            corner_radius, front_offset, rear_offset,
            sheet_size, margin, spacing, window_mode,
            operation);
}
