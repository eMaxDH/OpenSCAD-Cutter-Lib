use <../../cutter_lib/layout/cl_cut_layout.scad>
use <../../cutter_lib/calibration/ccal_laser_coupon.scad>
use <../../cutter_lib/shells/csh_ribbed_veneer.scad>
use <../../cutter_lib/hinges/ch_pin_hinge.scad>
use <../../cutter_lib/trays/ctr_removable_tray.scad>
use <bob_body.scad>
use <bob_door.scad>
use <bob_chamber.scad>
use <bob_rack.scad>

module bob_part_label(id, position=[1,1], size=1.8)
{
    %translate(position) {
        text(id, size=size);
        translate([0, size+0.8])
            polygon([[0,0], [3,0.8], [0,1.6]]);
    }
}

module bob_plywood_sheet_1(model_width, model_height, model_depth,
                           plywood_thickness=4,
                           kerf=0.5, fit_clearance=0.15,
                           rib_count=4,
                           corner_radius=8,
                           pin_diameter=2,
                           pin_clearance=0.2,
                           sheet_size=[300,300],
                           margin=5, spacing=3)
{
    total_ribs = rib_count+2;
    assert(total_ribs == 6,
           "bob_plywood_sheet_1: current deterministic layout expects four internal ribs");

    dw = bob_door_width(model_width);
    dh = bob_door_height(model_height);
    base = [model_width-2*plywood_thickness,
            model_depth-2*plywood_thickness];
    cage_h = 4*plywood_thickness+3*spacing;
    x4 = margin+3*(model_width+spacing);
    door_y = margin;
    base_y = door_y+dh+spacing;
    cage_y = base_y+base[1]+spacing;
    hinge_y = cage_y;

    rib_boxes = [
        [margin, margin, model_width, model_height],
        [margin+model_width+spacing, margin,
         model_width, model_height],
        [margin+2*(model_width+spacing), margin,
         model_width, model_height],
        [margin, margin+model_height+spacing,
         model_width, model_height],
        [margin+model_width+spacing,
         margin+model_height+spacing,
         model_width, model_height],
        [margin+2*(model_width+spacing),
         margin+model_height+spacing,
         model_width, model_height]
    ];
    boxes = concat(rib_boxes, [
        [x4, door_y, dw, dh],
        [x4, base_y, base[0], base[1]],
        [x4, cage_y, cage_h,
         model_depth-2*plywood_thickness],
        [x4+cage_h+spacing, hinge_y,
         5*plywood_thickness+spacing, 3*plywood_thickness]
    ]);

    cl_validate_layout(
        boxes, sheet_size, margin, spacing,
        "BOB plywood sheet 1");
    cl_sheet_boundary(sheet_size, "BOB plywood 4 mm - sheet 1");

    rib_ids = [
        "BOB-FRONT-FRAME",
        "BOB-RIB-01", "BOB-RIB-02",
        "BOB-RIB-03", "BOB-RIB-04",
        "BOB-REAR-FRAME"
    ];
    for (i = [0:5])
        cl_layout_part(
            [rib_boxes[i][0], rib_boxes[i][1]],
            [model_width, model_height],
            rib_ids[i], sheet_size=sheet_size, margin=margin) {
                bob_shell_rib_2d(
                    model_width, model_height,
                    plywood_thickness,
                    corner_radius,
                    fit_clearance, kerf);
                bob_part_label(
                    rib_ids[i],
                    [plywood_thickness+1,
                     plywood_thickness+1]);
            }

    cl_layout_part(
        [x4, door_y], [dw, dh],
        "BOB-DOOR-FRAME",
        sheet_size=sheet_size, margin=margin) {
            bob_door_frame_2d(
                dw, dh,
                max(5, plywood_thickness),
                min(6, dw*0.12));
            bob_part_label("BOB-DOOR-FRAME");
        }

    cl_layout_part(
        [x4, base_y], base,
        "BOB-BASE",
        sheet_size=sheet_size, margin=margin) {
            square(base);
            bob_part_label("BOB-BASE");
        }

    // Four longitudinal registration stringers, rotated for compact packing.
    for (i = [0:3])
        translate([x4+i*(plywood_thickness+spacing), cage_y])
            square([plywood_thickness,
                    model_depth-2*plywood_thickness]);
    bob_part_label("BOB-STRINGER x4", [x4, cage_y+1]);

    for (i = [0:1])
        translate([x4+cage_h+spacing+
                   i*(2.5*plywood_thickness+spacing),
                   hinge_y])
            ch_pin_hinge_cheek_2d(
                2.5*plywood_thickness,
                3*plywood_thickness,
                pin_diameter,
                pin_clearance,
                kerf,
                hole_center=[
                    1.25*plywood_thickness,
                    1.5*plywood_thickness],
                edge_min=1);
    bob_part_label("BOB-HINGE-L/R",
                   [x4+cage_h+spacing, hinge_y+1]);
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
    runner_region = [2*plywood_thickness+spacing, cd];

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
        square([cw,ch]);

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
        removable_tray(
            rack,
            thickness=plywood_thickness/2,
            make_3d=false);

    // Tray runners / side rails.
    for (i = [0:1])
        translate([margin+rack[0]+spacing+
                   i*(plywood_thickness+spacing),
                   row3_y])
            tray_runner(
                cd,
                width=plywood_thickness,
                height=plywood_thickness,
                make_3d=false);
    bob_part_label(
        "BOB-TRAY-RUNNER x2",
        [margin+rack[0]+spacing, row3_y+1]);

    cl_layout_part(
        [margin+rack[0]+2*spacing+runner_region[0],
         row3_y],
        [85,42], "BOB-CAL-01",
        sheet_size=sheet_size, margin=margin)
        ccal_laser_coupon(
            plywood_thickness, kerf, pin_diameter);
}

module bob_veneer_sheet(model_width, model_height, model_depth,
                        plywood_thickness=4,
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
    dw = bob_door_width(model_width);
    dh = bob_door_height(model_height);
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
    assert(operation != "engrave" || material == "veneer",
           "bob_cut_layout: engraving exists only on the veneer sheet");

    if (material == "all" || material == "plywood_1")
    translate(material == "all" ? [0,0] : [0,0])
    bob_plywood_sheet_1(
        model_width, model_height, model_depth,
        plywood_thickness, kerf, fit_clearance,
        rib_count, corner_radius,
        pin_diameter, pin_clearance,
        sheet_size, margin, spacing);

    if (material == "all" || material == "plywood_2")
    translate(material == "all"
              ? [sheet_size[0]+sheet_gap,0]
              : [0,0])
        bob_plywood_sheet_2(
            model_width, model_height, model_depth,
            plywood_thickness, kerf, fit_clearance,
            pin_diameter,
            sheet_size, margin, spacing);

    if (material == "all" || material == "veneer")
    translate(material == "all"
              ? [2*(sheet_size[0]+sheet_gap),0]
              : [0,0])
        bob_veneer_sheet(
            model_width, model_height, model_depth,
            plywood_thickness,
            corner_radius, front_offset, rear_offset,
            sheet_size, margin, spacing, window_mode,
            operation);
}
