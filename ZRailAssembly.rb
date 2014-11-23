require_relative 'enclosure'    # For DeckPanel
require_relative 'sprockets'

require_relative 'PistonAssembly'
require_relative 'TopRetainer'

# The distance between the leadscrew pulley and the motor pulley
# Assuming 2mm pitch GT2 belt...
# distance = (Belt_teeth - Pulley_teeth)
PULLEY_SPACING = (101 - 20).mm + 1.mm   # Add 1mm for tensioning

# TR10x2 Trapezoidal leadscrew
model :Leadscrew do
    attr_reader length:Z_RAIL_LENGTH - DeckPanel.length     # Overall length (including the turned ends)
    attr_reader machined_length: 5.mm                       # The length of the turned ends
    attr_reader threaded_length: length - 2*machined_length

    # The bottom machined end
    extrude length:machined_length do
        circle diameter:8.mm
    end

    # The threaded portion
    extrude length:length, origin:[0,0,machined_length] do
        circle diameter:10.mm
    end

    # The top machined end
    extrude length:machined_length, origin:[0,0,machined_length + threaded_length] do
        circle diameter:8.mm
    end
end

model :ZMotorAssembly do
    push NEMA17
    push Sprocket_GT2_36_5mm, origin:[0, 0, NEMA17.body_length + NEMA17.shaft_length - 5.mm], x:X, y:-Y
end

# The origin of this part is centered between the leadscrews
extrusion :BottomRetainerFront do
    attr_reader rail_spacing: Z_RAIL_SPACING

    length ACRYLIC_THICKNESS

    rectangle origin:[-5.cm, -2.25.cm], size:[10.cm, 4.5.cm]

    # Leadscrew bearing hole
    repeat step:rail_spacing, count:2 do
        circle diameter:15.9.mm  # Sized for press fit
    end

    # Bolt holes
    repeat step:[rail_spacing, 3.cm], count:2 do
        circle diameter:5.mm
    end
end

# The origin of this part is aligned with the leadscrew center axis
extrusion :BottomRetainer do
    attr_reader motor_belt_length: PULLEY_SPACING
    attr_reader rail_spacing: Z_RAIL_SPACING

    length ACRYLIC_THICKNESS

    rectangle origin:[-4.cm, -2.25.cm], size:[14.5.cm, 4.5.cm]

    # Leadscrew bearing hole
    repeat step:rail_spacing, count:2 do
        circle diameter:15.9.mm  # Sized for press fit
    end

    # Bolt holes
    repeat step:[rail_spacing, 3.cm], count:2 do
        circle diameter:5.mm
    end

    translate x:motor_belt_length do
        NEMA17.bolt_holes.each do |x,y|
            circle center:[x, y], diameter:NEMA17.bolt_hole_diameter.cm
        end
    end
end

model :ZRailAssembly do
    attr_reader motor_group_y: PLATFORM_SIZE.y/2 + 3.cm
    attr_reader rail_length: Z_RAIL_LENGTH

    # The front side of the assembly
    translate y:-motor_group_y do
        translate z:-rail_length do
            # Front-left screw and sprockets
            translate x:-Z_RAIL_SPACING/2 do
                push Sprocket_GT2_36_10mm, origin:[0, 0, 18.mm]
            end

            # Front-right screw and sprockets
            translate x:Z_RAIL_SPACING/2 do
                push Sprocket_GT2_36_10mm, origin:[0, 0, 18.mm]
                push Sprocket_GT2_36_10mm, origin:[0, 0, 50.mm], x:X, y:-Y
            end

            [-Z_RAIL_SPACING/2, Z_RAIL_SPACING/2].each do |x|
                push Leadscrew, origin:[x,0,0]
            end

            push BottomRetainerFront
        end
        push TopRetainer, origin:[0, 0, -DeckPanel.thickness - TopRetainer.length]
    end

    # The back side of the assembly
    translate y:motor_group_y do
        translate z:-rail_length do
            translate z:BottomRetainer.length do
                push ZMotorAssembly, origin:[PULLEY_SPACING, 0, 0], x:X, y:Y
            end

            # Rear-left sprocket
            push Sprocket_GT2_36_10mm, origin:[-Z_RAIL_SPACING/2, 0, 34.mm]

            # Rear-right sprockets
            translate x:Z_RAIL_SPACING/2, z:18.mm do
                push Sprocket_GT2_36_10mm
                push Sprocket_GT2_36_10mm, origin:[0, 0, 16.mm]
                push Sprocket_GT2_36_5mm, origin:[0, 0, 32.mm]
            end

            [-Z_RAIL_SPACING/2, Z_RAIL_SPACING/2].each do |x|
                push Leadscrew, origin:[x,0,0]
            end

            push BottomRetainer
        end
        push TopRetainer, origin:[0, 0, -DeckPanel.thickness - TopRetainer.length]

        translate x:BottomRetainer.motor_belt_length do
            NEMA17.bolt_holes.each do |x,y|
                push M3x60Bolt, origin:[x, y, -rail_length - BottomPanel.thickness]
            end
        end

    end

    # Piston assembly
    push PistonAssembly, origin:[0, 0, DeckPanel.thickness]
end
