include <box.scad>

make_3d=true;

thickness=3; //[1:10]
frame_width=7; //[1:10]

box(290, 222, 243, frame_width=frame_width, thickness=thickness, make_3d=make_3d,
    top=false, bottom=false, left=true, right=true, front=true, back=true);

// box(290, 222, 243, frame_width=frame_width, thickness=thickness, make_3d=make_3d,
//     top=true, bottom=true, left=true, right=true, front=true, back=true);

// box(200, 100, 50, frame_width=frame_width, thickness=thickness, make_3d=make_3d,
//     top=true, bottom=true, left=true, right=true, front=true, back=true);