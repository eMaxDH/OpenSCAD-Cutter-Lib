include <box.scad>
include <floor_connector.scad>

module create_floors(box_width=290, box_height=221, box_depth=243, box_thickness=3, facing_thickness=10, frame_width=7, make_3d=false,
                    top=false, bottom=false, left=true, right=true, front=true, back=true, no_floors=2)
{
    floor_connector_width=box_width+2;
    floor_connector_height=7;
    floor_connector_depth=box_depth+2;

    box_base_floor(box_width=box_width, box_height=box_height, box_depth=box_depth, frame_width=frame_width, thickness=box_thickness, make_3d=make_3d,
        top=top, bottom=bottom, left=left, right=right, front=front, back=back, facing_thickness=facing_thickness);

    if (make_3d) {

        for (i = [2 : no_floors]) {
            translate([0, 0, (i-1)*box_height])
            {
                create_floor(box_width, box_height, box_depth, frame_width, box_thickness, make_3d,
                    top, bottom, left, right, front, back,
                    floor_connector_width, floor_connector_height, floor_connector_depth);
            }

            translate([0,0,i*box_height])
                color("silver")
                translate([-(floor_connector_width-box_width)/2, -(floor_connector_depth-box_depth)/2, -floor_connector_height/2])
                floor_connector(floor_connector_width, floor_connector_height, floor_connector_depth, thickness=2, make_3d=make_3d);

        }
    }
    else{
        for (i = [2 : no_floors]) {
            translate([0, i*4*box_depth, 0]) {
                create_floor(box_width, box_height, box_depth, frame_width, box_thickness, make_3d,
                    top, bottom, left, right, front, back,
                    floor_connector_width, floor_connector_height, floor_connector_depth);
            }
        }
    }
}


module create_floor(box_width, box_height, box_depth, frame_width, thickness, make_3d,
                    top, bottom, left, right, front, back,
                    floor_connector_width, floor_connector_height, floor_connector_depth, facing_thickness)
{
    color("silver")
        translate([-(floor_connector_width-box_width)/2, -(floor_connector_depth-box_depth)/2, -floor_connector_height/2])
        floor_connector(floor_connector_width, floor_connector_height, floor_connector_depth, thickness=2, make_3d=make_3d);

    box_additional(box_width=box_width, box_height=box_height, box_depth=box_depth, frame_width=frame_width, thickness=box_thickness, make_3d=make_3d,
        top=top, bottom=bottom, left=left, right=right, front=front, back=back, facing_thickness=facing_thickness);
}