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
    echo(str("[BOB PART MANIFEST] plywood=", 16+rib_segments,
             " cut parts (including ", logical_ribs,
             " logical ribs / ", rib_segments,
             " glued rib segments and coupon), veneer=4 cut parts, purchased hinge pin=1"));

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
                           kerf=0.5, fit_clearance=0.15,
                           rib_count=4,
                           corner_radius=8,
                           door_gap=0.4,
                           sheet_size=[300,300],
                           margin=5, spacing=3)
{
    total_ribs = rib_count+2;
    assert(total_ribs == 6,
           "bob_plywood_sheet_1: current deterministic layout expects four internal ribs");

    dw = bob_door_width(
        model_width, plywood_thickness, door_gap);
    dh = bob_door_height(
        model_height, plywood_thickness, door_gap);
    base = [model_width-2*plywood_thickness,
            model_depth];
    cap_piece_h = bob_rib_cap_piece_height(
        corner_radius, plywood_thickness);
    side_length = bob_rib_side_length(
        model_height, corner_radius, plywood_thickness);
    cap_columns = 4;
    cap_rows = ceil(2*total_ribs/cap_columns);
    cap_boxes = [
        for (i = [0:2*total_ribs-1])
            [
                margin+(i%cap_columns)*(model_width+spacing),
                margin+floor(i/cap_columns)*(cap_piece_h+spacing),
                model_width, cap_piece_h
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
    cage_x = base_x+base[0]+spacing;
    cage_width = 2*plywood_thickness+spacing;

    boxes = concat(cap_boxes, side_boxes, [
        [door_x, parts_y, dw, dh],
        [base_x, parts_y, base[0], base[1]],
        [cage_x, parts_y, cage_width,
         model_depth]
    ]);

    cl_validate_layout(
        boxes, sheet_size, margin, spacing,
        "BOB plywood sheet 1");
    cl_sheet_boundary(sheet_size, "BOB plywood 4 mm - sheet 1");

    old_rib_box_area =
        total_ribs*model_width*model_height;
    segmented_rib_box_area =
        total_ribs*(
            2*model_width*cap_piece_h+
            2*plywood_thickness*side_length);
    echo(str(
        "[BOB RIB NESTING] allocated rib footprint ",
        old_rib_box_area, " -> ", segmented_rib_box_area,
        " mm^2 (",
        100*(old_rib_box_area-segmented_rib_box_area)/
            old_rib_box_area,
        "% reduction)"));

    rib_ids = [
        "BOB-FRONT-FRAME",
        "BOB-RIB-01", "BOB-RIB-02",
        "BOB-RIB-03", "BOB-RIB-04",
        "BOB-REAR-FRAME"
    ];

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
            [model_width, cap_piece_h],
            segment_id,
            sheet_size=sheet_size, margin=margin) {
                bob_rib_cap_2d(
                    model_width, model_height,
                    plywood_thickness, corner_radius,
                    top, fit_clearance, kerf);
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
                    model_height, plywood_thickness,
                    corner_radius, fit_clearance, kerf);
    }

    cl_layout_part(
        [door_x, parts_y], [dw, dh],
        "BOB-DOOR-FRAME",
        sheet_size=sheet_size, margin=margin) {
            bob_door_frame_2d(
                dw, dh,
                max(5, plywood_thickness),
                min(6, dw*0.12));
            bob_part_label("BOB-DOOR-FRAME");
        }

    cl_layout_part(
        [base_x, parts_y], base,
        "BOB-BASE",
        sheet_size=sheet_size, margin=margin) {
            bob_base_2d(
                model_width, model_depth,
                plywood_thickness);
            bob_part_label("BOB-BASE");
        }

    // Two full-depth upper stringers; the base replaces the redundant lower
    // pair as the lower longitudinal structure.
    for (i = [0:1])
        translate([cage_x+i*(plywood_thickness+spacing), parts_y])
            bob_stringer_2d(
                model_depth, plywood_thickness);
    bob_part_label("BOB-STRINGER x2", [cage_x, parts_y+1]);
}

module bob_plywood_sheet_2(model_width, model_height, model_depth,
                           plywood_thickness=4,
                           kerf=0.5, fit_clearance=0.15,
                           pin_diameter=2,
                           sheet_size=[300,300],
                           margin=5, spacing=3)
{
    cw = bob_chamber_width(model_width, plywood_thickness);
    ch = bob_chamber_height(model_height, plywood_thickness);
    cd = bob_chamber_depth(model_depth, plywood_thickness);
    rack = bob_rack_size(
        model_width, model_depth, plywood_thickness);
    row1_h = max(ch, cd);
    row2_y = margin+row1_h+spacing;
    row3_y = row2_y+ch+spacing;
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
        [margin, margin, cw, ch],
        [margin+cw+spacing, margin, floor_bound[0], floor_bound[1]],
        [margin+cw+spacing+floor_bound[0]+spacing,
         margin, floor_bound[0], floor_bound[1]],
        [margin, row2_y, cd, ch],
        [margin+cd+spacing, row2_y, cd, ch],
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
        [margin,margin], [cw,ch], "BOB-CHAMBER-REAR",
        sheet_size=sheet_size, margin=margin)
        bob_chamber_rear_2d(cw, ch);

    cl_layout_part(
        [margin+cw+spacing,margin], floor_bound,
        "BOB-CHAMBER-FLOOR",
        sheet_size=sheet_size, margin=margin)
        translate([plywood_thickness,0])
            bob_chamber_floor_2d(
                cw, cd, plywood_thickness,
                fit_clearance, kerf);

    cl_layout_part(
        [margin+cw+spacing+floor_bound[0]+spacing,
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
        [margin+cd+spacing,row2_y], [cd,ch],
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
    margin=5, spacing=3)
{
    cw = bob_chamber_width(model_width, plywood_thickness);
    cd = bob_chamber_depth(model_depth, plywood_thickness);
    floor_x = margin+cw+spacing;

    translate([
        floor_x+plywood_thickness+cw/2,
        margin+cd*0.55])
        bob_chamber_spray_arm_2d(cw);
}

module bob_veneer_sheet(model_width, model_height, model_depth,
                        plywood_thickness=4,
                        door_gap=0.4,
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
    skin_depth = model_depth-front_offset-rear_offset;
    dw = bob_door_width(
        model_width, plywood_thickness, door_gap);
    dh = bob_door_height(
        model_height, plywood_thickness, door_gap);
    row2_y = margin+skin_depth+spacing;

    boxes = [
        [margin, margin, wrap, skin_depth],
        [margin, row2_y, dw, dh],
        [margin+dw+spacing, row2_y,
         model_width, model_height],
        [margin+dw+spacing+model_width+spacing,
         row2_y, model_width, model_height]
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
                corner_radius, front_offset, rear_offset);

    cl_layout_part(
        [margin,row2_y], [dw,dh],
        "BOB-DOOR-FASCIA",
        sheet_size=sheet_size, margin=margin)
        {
            cl_operation_geometry("cut", operation)
                bob_door_fascia_2d(
                    dw, dh, min(6,dw*0.12), window_mode);
            cl_operation_geometry("engrave", operation)
                bob_door_engraving_2d(dw, dh);
        }

    if (operation != "engrave")
    cl_layout_part(
        [margin+dw+spacing,row2_y],
        [model_width,model_height],
        "BOB-FRONT-VENEER-FRAME",
        sheet_size=sheet_size, margin=margin)
        cl_operation_geometry("cut", operation)
            shell_rib(
                model_width, model_height,
                rib_width=plywood_thickness,
                corner_radius=corner_radius);

    if (operation != "engrave")
    cl_layout_part(
        [margin+dw+spacing+model_width+spacing,
         row2_y],
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
                      door_gap=0.4,
                      sheet_size=[300,300],
                      margin=5, spacing=3,
                      window_mode="open",
                      material="all",
                      operation="cut")
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
        plywood_thickness, kerf, fit_clearance,
        rib_count, corner_radius,
        door_gap,
        sheet_size, margin, spacing);

    if (material == "all" || material == "plywood_2")
    translate(material == "all"
              ? [sheet_size[0]+sheet_gap,0]
              : [0,0])
        cl_operation_geometry("cut", operation)
        bob_plywood_sheet_2(
            model_width, model_height, model_depth,
            plywood_thickness, kerf, fit_clearance,
            pin_diameter,
            sheet_size, margin, spacing);

    if (material == "all" || material == "plywood_2")
    translate(material == "all"
              ? [sheet_size[0]+sheet_gap,0]
              : [0,0])
        cl_operation_geometry("engrave", operation)
        bob_plywood_sheet_2_engraving(
            model_width, model_height, model_depth,
            plywood_thickness,
            sheet_size, margin, spacing);

    if (material == "all" || material == "veneer")
    translate(material == "all"
              ? [2*(sheet_size[0]+sheet_gap),0]
              : [0,0])
        bob_veneer_sheet(
            model_width, model_height, model_depth,
            plywood_thickness, door_gap,
            corner_radius, front_offset, rear_offset,
            sheet_size, margin, spacing, window_mode,
            operation);
}
