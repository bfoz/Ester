# The distance between the leadscrew pulley and the motor pulley
# Assuming 2mm pitch GT2 belt...
# distance = (Belt_teeth - Pulley_teeth)
PULLEY_SPACING = (81 - 20).mm + 1.mm   # Add 1mm for tensioning

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

extrusion :TopRetainerBack do
    attr_reader motor_belt_length: PULLEY_SPACING
    attr_reader thickness: ACRYLIC_THICKNESS

    length thickness

    attr_reader bolt_holes: repeat(spacing:[0, 2.2.cm], count:2)
    attr_reader bolt_hole_diameter: 5.mm

    attr_reader bearing_holes: repeat(spacing:Z_RAIL_SPACING, count:2)
    attr_reader bearing_hole_diameter: 15.9.mm  # Sized for press fit

    # rectangle center:[0,0], size:[9.cm, 5.5.cm]
    polygon origin:[-5.25.cm, -2.75.cm] do
        up      7.cm
        up      NEMA17.body_width
        right   NEMA17.body_width + 0.5.cm
        down    6.5.cm
        right_to    10.cm
        down_to 0
    end

    # Leadscrew bearing holes
    bearing_holes.each {|center| circle center:center, diameter:bearing_hole_diameter }

    # Bolt holes
    bolt_holes.each {|center| circle center:center, diameter:bolt_hole_diameter }

    # Motor bolt holes
    translate -Z_RAIL_SPACING/2, motor_belt_length do
        NEMA17.bolt_holes.each do |center|
            circle center:center, diameter:NEMA17.bolt_hole_diameter
        end
    end
end
