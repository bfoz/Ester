extrusion :TopRetainer do
    attr_reader thickness: ACRYLIC_THICKNESS

    length thickness

    attr_reader bolt_holes: repeat(spacing:[0, 2.2.cm], count:2)
    attr_reader bolt_hole_diameter: 5.mm

    attr_reader bearing_holes: repeat(spacing:Z_RAIL_SPACING, count:2)
    attr_reader bearing_hole_diameter: 15.9.mm  # Sized for press fit

    rectangle center:[0,0], size:[9.cm, 5.5.cm]

    # Leadscrew bearing holes
    bearing_holes.each {|center| circle center:center, diameter:bearing_hole_diameter }

    # Bolt holes
    bolt_holes.each {|center| circle center:center, diameter:bolt_hole_diameter }
end
