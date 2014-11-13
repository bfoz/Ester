extrusion :TopRetainer do
    length ACRYLIC_THICKNESS

    attr_reader bolt_holes: repeat(spacing:[Z_RAIL_SPACING, 3.cm], count:2)
    attr_reader bolt_hole_diameter: 5.mm

    attr_reader rail_holes: repeat(spacing:Z_RAIL_SPACING, count:2)
    attr_reader rail_hole_diameter: 8.mm

    rectangle center:[0,0], size:[7.5.cm, 4.cm]

    # Leadscrew bearing hole
    circle diameter:15.9.mm  # Sized for press fit

    # Smooth rod pass-thru holes
    rail_holes.each {|center| circle center:center, diameter:rail_hole_diameter}

    # Bolt holes
    bolt_holes.each {|center| circle center:center, diameter:bolt_hole_diameter }

    # Identifying mark
    circle center:[1.5.cm, 0], diameter:5.mm
end
