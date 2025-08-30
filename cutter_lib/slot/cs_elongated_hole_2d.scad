module create_slot(width, height)
{
    spacing=0.001;
    translate([-width/2, 0, 0])
    minkowski()
    {
      square([width, spacing]);
      circle(height/2-2*spacing);
    }
}