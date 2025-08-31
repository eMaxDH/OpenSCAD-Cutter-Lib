
colors = [
    [0.1, 0.1, 0.1, 1],
    [0.2, 0.2, 0.2, 1],
    [0.3, 0.3, 0.3, 1],
    [0.4, 0.4, 0.4, 1],
    [0.5, 0.5, 0.5, 1],
    [0.6, 0.6, 0.6, 1]
];

default_color = "gray";

function cs_testface_get_color(number) =
    (number < 6 && number >= 0)
    ? 
        colors[number]
    : 
        default_color;

module cs_test_face_2d(width, height, number=0, face_color="") {

    text_size = get_cs_test_face_2d_text_size(width, height);

    color("red")
    translate([width/2,height/2,1])
        text(str(number,"."), size=text_size, halign="center", valign="center");
    
    if (face_color == "")
        color(cs_testface_get_color(number))
            square([width, height], center=false);
    else
        color(face_color)
            square([width, height], center=false);
    
    color("green")
    translate([width/2,height/2,-1])
        text(str(number,"."), size=text_size, halign="center", valign="center");
}

module cs_test_face_2d_top(width=15, height=10, number=0)
{
    text_size = get_cs_test_face_2d_text_size(width, height);

    color("red")
    translate([width/2,height/2,0])
        text(str(number,"."), size=text_size, halign="center", valign="center");
}

module cs_test_face_2d_middle(width=15, height=10, number=0)
{
    text_size = get_cs_test_face_2d_text_size(width, height);

    color(cs_testface_get_color(number))
        square([width, height], center=false);
}

module cs_test_face_2d_bottom(width=15, height=10, number=0)
{
    text_size = get_cs_test_face_2d_text_size(width, height);
    
    color("green")
    translate([width/2,height/2,0])
        text(str(number,"."), size=text_size, halign="center", valign="center");
}

function get_cs_test_face_2d_text_size(width, height) =
    (width > height) ? height/ 2 : width / 2;