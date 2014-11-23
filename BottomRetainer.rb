require_relative 'bearings/f608zz'

FlangedBearing = F608ZZ

# The distance between the leadscrew pulley and the motor pulley
# Assuming 2mm pitch GT2 belt...
# distance = (Belt_teeth - Pulley_teeth)
PULLEY_SPACING = (101 - 20).mm + 1.mm   # Add 1mm for tensioning

# The origin of this part is centered between the leadscrews
extrusion :BottomRetainerFront do
    attr_reader rail_spacing: Z_RAIL_SPACING
    attr_reader thickness:ACRYLIC_THICKNESS

    attr_reader mounting_bolt_holes: repeat(step:[0, 4.cm], count:2)

    length thickness

    rectangle origin:[-5.cm, -2.75.cm], size:[10.cm, 5.5.cm]

    # Leadscrew bearing hole
    repeat step:rail_spacing, count:2 do
        circle diameter:FlangedBearing.outer_diameter
    end

    # Mounting Bolt holes
    mounting_bolt_holes.each {|center| circle center:center, diameter:5.mm }
end

# The origin of this part is aligned with the leadscrew center axis
extrusion :BottomRetainer do
    attr_reader motor_belt_length: PULLEY_SPACING
    attr_reader rail_spacing: Z_RAIL_SPACING
    attr_reader thickness:ACRYLIC_THICKNESS

    attr_reader mounting_bolt_holes: repeat(step:[0, 4.cm], count:2)
    attr_reader mounting_bolt_diameter: 5.mm

    length thickness

    rectangle origin:[-4.5.cm, -2.75.cm], size:[15.cm, 5.5.cm]

    # Leadscrew bearing hole
    repeat step:rail_spacing, count:2 do
        circle diameter:FlangedBearing.outer_diameter
    end

    # Mounting Bolt holes
    mounting_bolt_holes.each {|center| circle center:center, diameter:mounting_bolt_diameter }

    translate x:motor_belt_length do
        NEMA17.bolt_holes.each do |x,y|
            circle center:[x, y], diameter:NEMA17.bolt_hole_diameter.cm
        end
    end
end
