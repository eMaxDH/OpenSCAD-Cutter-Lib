
module facing_element_2d(width, height)
{
    square([width, height]);
}

module facing_2d(width, height, element_width, no_of_elements=2)
{
    function calculate_element_spacing(width, element_width, no_of_elements) = 
        (width - element_width) / (no_of_elements-1) - element_width;
    
    function calculate_element_position(index) = 
        let (spacing = calculate_element_spacing(width, element_width, no_of_elements))
        [index * (element_width + spacing), 0, 0];
    

    for (i = [0 : no_of_elements-1])
    {   
        translate(calculate_element_position(i))
            facing_element_2d(element_width, height);
    }
}