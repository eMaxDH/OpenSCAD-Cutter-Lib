width=50; //[10:100]
height=20; //[1:100]
spacing=0.1; //[0.001:0.1:10]

cs_elongated_hole_2d(width, height, spacing);

module cs_elongated_hole_2d(width, height, spacing=0.001)
{
    square_width = width - height + spacing;
    translate([-square_width/2, -spacing/2, 0])
    minkowski()
    {
      square([square_width, spacing]);
      circle(height/2-spacing/2);
    }
}