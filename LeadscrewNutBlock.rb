extrusion :LeadscrewNutBlock do
    attr_reader height: 15.mm
    attr_reader width: 35.mm
    attr_reader shaft_diameter: 10.mm

    attr_reader bolt_holes: repeat(step:[20.mm,0], count:2)
    attr_reader bolt_hole_diameter: 5.mm

    length  20.mm

    rectangle center:[0,0], size:[width, height]    

    circle diameter:shaft_diameter
end
