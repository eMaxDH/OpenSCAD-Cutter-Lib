// include <box.scad>
// include <floor_connector.scad>

// include <floors.scad>

make_3d=true;

box_thickness=3; //[1:0.5:10]
facing_thickness=0.6; //[0.1:0.1:1]
frame_width=7; //[1:0.5:10]

top=false;
bottom=false;
left=true;
right=true;
front=true;
back=true;


box_width=290; //[50:1:500]
box_height=221; //[50:1:500]
box_depth=243; //[50:1:500]

floor_connector_width=box_width+2;
floor_connector_height=7;
floor_connector_depth=box_depth+2;

no_floors=2;

// // ----- test frame -----
// include <frame.scad>
// frame(width=100, height=50, thickness=7, hole_distance=[80, 40], hole_radius=2, make_3d=make_3d);

// ----- test box -----
include <box.scad>
box(width=290, height=221, depth=243, frame_width=10, thickness = 0, make_3d=make_3d,
            top=true, bottom=true, left=true, right=false, front=false, back=false,
            facing_thickness=1, spacing_2d=1);

// box(width=290, height=221, depth=243, make_3d=make_3d);

// create_floors(box_width=box_width, box_height=box_height, box_depth=box_depth, box_thickness=box_thickness, facing_thickness=facing_thickness, frame_width=frame_width, make_3d=make_3d,
//     top=top, bottom=bottom, left=left, right=right, front=front, back=back);

// box_base_floor(box_width=box_width, box_height=box_height, box_depth=box_depth, frame_width=frame_width, thickness=box_thickness, make_3d=make_3d,
//     top=top, bottom=bottom, left=left, right=right, front=front, back=back);



// if (make_3d) {

//     for (i = [2 : no_floors]) {
//         translate([0, 0, (i-1)*box_height])
//         {
//             create_floor(box_width, box_height, box_depth, frame_width, box_thickness, make_3d,
//                 top, bottom, left, right, front, back,
//                 floor_connector_width, floor_connector_height, floor_connector_depth);
//         }

//         translate([0,0,i*box_height])
//             color("silver")
//             translate([-(floor_connector_width-box_width)/2, -(floor_connector_depth-box_depth)/2, -floor_connector_height/2])
//             floor_connector(floor_connector_width, floor_connector_height, floor_connector_depth, thickness=2, make_3d=make_3d);

//     }
// }
// else{
//     for (i = [2 : no_floors]) {
//         translate([0, i*4*box_depth, 0]) {
//             create_floor(box_width, box_height, box_depth, frame_width, box_thickness, make_3d,
//                 top, bottom, left, right, front, back,
//                 floor_connector_width, floor_connector_height, floor_connector_depth);
//         }
//     }
// }

// module create_floor(box_width, box_height, box_depth, frame_width, thickness, make_3d,
//                     top, bottom, left, right, front, back,
//                     floor_connector_width, floor_connector_height, floor_connector_depth)
// {
//     color("silver")
//         translate([-(floor_connector_width-box_width)/2, -(floor_connector_depth-box_depth)/2, -floor_connector_height/2])
//         floor_connector(floor_connector_width, floor_connector_height, floor_connector_depth, thickness=2, make_3d=make_3d);

//     box_additional(box_width, box_height, box_depth, frame_width=frame_width, thickness=box_thickness, make_3d=make_3d,
//         top=top, bottom=bottom, left=left, right=right, front=front, back=back);
// }