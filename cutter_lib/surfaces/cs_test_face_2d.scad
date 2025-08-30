
module cs_test_face_2d(width, height, thickness=1, number=0) {
    color("red")
    translate([width/4,height/4,thickness])
        text(str(number,"."), size=0.5*height);
    
    color("gray")
    square([width, height], center=false);
    
    color("green")
    translate([width/4,height/4,-thickness])
        text(str(number,"."), size=0.5*height);
}