require_relative 'bearings/f608zz'

FlangedBearing = F608ZZ

# The origin of this part is centered between the leadscrews
extrusion :BottomRetainer do
    attr_reader rail_spacing: Z_RAIL_SPACING
    attr_reader thickness:ACRYLIC_THICKNESS

    attr_reader mounting_bolt_holes: repeat(step:[0, 4.cm], count:2)
    attr_reader mounting_bolt_diameter: 5.mm

    length thickness

    rectangle origin:[-5.cm, -2.75.cm], size:[10.cm, 5.5.cm]

    # Leadscrew bearing hole
    repeat step:rail_spacing, count:2 do
        circle diameter:FlangedBearing.outer_diameter
    end

    # Mounting Bolt holes
    mounting_bolt_holes.each {|center| circle center:center, diameter:5.mm }
end
