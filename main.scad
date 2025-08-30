include <box.scad>

make_3d=true;

box_thickness=3; //[1:0.5:10]
frame_width=7; //[1:0.5:10]

top=false;
bottom=false;
left=true;
right=true;
front=true;
back=true;


box_width=290; //[50:1:500]
box_height=243; //[50:1:500]
box_depth=243; //[50:1:500]

box(box_width, box_height, box_depth, frame_width=frame_width, thickness=box_thickness, make_3d=make_3d,
    top=top, bottom=bottom, left=left, right=right, front=front, back=back);

// include <facing.scad>

// facing_thickness=0.5; //[0.1:0.1:2.0]
// facing_element_width=20; //[5:1:100]
// facing_element_no=5; //[1:1:20]

// facing(box_width, box_height, facing_element_width, facing_element_no, thickness=facing_thickness, make_3d=make_3d);