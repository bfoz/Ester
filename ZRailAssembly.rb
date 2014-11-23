require_relative 'enclosure'    # For DeckPanel
require_relative 'sprockets'

require_relative 'PistonAssembly'
require_relative 'TopRetainer'

require_relative 'BottomRetainer'

# TR10x2 Trapezoidal leadscrew
model :Leadscrew do
    attr_reader length:Z_RAIL_LENGTH - DeckPanel.length - TopRetainer.thickness + 1.mm     # Overall length (including the turned ends)
    attr_reader machined_length: 5.mm                       # The length of the turned ends
    attr_reader threaded_length: length - 2*machined_length

    # The bottom machined end
    extrude length:machined_length do
        circle diameter:8.mm
    end

    translate z:machined_length do
        # The threaded portion
        extrude length:threaded_length do
            circle diameter:10.mm
        end

        # The top machined end
        extrude length:machined_length, origin:[0, 0, threaded_length] do
            circle diameter:8.mm
        end
    end
end

model :ZMotorAssembly do
    push NEMA17
    push Sprocket_GT2_36_5mm, origin:[0, 0, NEMA17.body_length + NEMA17.shaft_length - 5.mm], x:X, y:-Y
end

model :ZRailAssembly do
    attr_reader rail_length: Z_RAIL_LENGTH
    attr_reader rail_spacing: Size[Z_RAIL_SPACING, PLATFORM_SIZE.y + 7.cm]

    # The front side of the assembly
    translate y:-rail_spacing.y/2 do
        translate z:-rail_length do
            # Front-left screw and sprockets
            translate x:-rail_spacing.x/2 do
                push Sprocket_GT2_36_10mm, origin:[0, 0, 18.mm]
            end

            # Front-right screw and sprockets
            translate x:rail_spacing.x/2 do
                push Sprocket_GT2_36_10mm, origin:[0, 0, 18.mm]
                push Sprocket_GT2_36_10mm, origin:[0, 0, 50.mm], x:X, y:-Y
            end

            translate z:BottomRetainer.length + FlangedBearing.flange_thickness do
                [-rail_spacing.x/2, rail_spacing.x/2].each do |x|
                    push FlangedBearing, origin:[x, 0, 0], x:X, y:-Y
                    push Leadscrew, origin:[x,0, -Leadscrew.machined_length]
                    push FlangedBearing, origin:[x, 0, Leadscrew.threaded_length]
                end
            end

            push BottomRetainerFront
            BottomRetainerFront.mounting_bolt_holes.each do |center|
                push M5x16Bolt, origin:[center.x, center.y, BottomRetainerFront.thickness], x:X, y:-Y
                push M5HexNut, origin:[center.x, center.y, -BottomPanel.thickness - M5HexNut.height]
            end
        end
        translate z:-DeckPanel.thickness - TopRetainer.length do
            push TopRetainer
            TopRetainer.bolt_holes.each do |center|
                push M5x16Bolt, origin:[center.x, center.y, 0]
                if center.y > 0
                    push M5HexNut, origin:[center.x, center.y, DeckPanel.thickness + TopRetainer.length]
                end
            end
        end
    end

    # The back side of the assembly
    translate y:rail_spacing.y/2 do
        translate z:-rail_length do
            translate z:BottomRetainer.length do
                push ZMotorAssembly, origin:[BottomRetainer.motor_belt_length, 0, 0], x:X, y:Y
            end

            # Rear-left sprocket
            push Sprocket_GT2_36_10mm, origin:[-rail_spacing.x/2, 0, 34.mm]

            # Rear-right sprockets
            translate x:rail_spacing.x/2, z:18.mm do
                push Sprocket_GT2_36_10mm
                push Sprocket_GT2_36_10mm, origin:[0, 0, 16.mm]
                push Sprocket_GT2_36_5mm, origin:[0, 0, 32.mm]
            end

            translate z:BottomRetainer.length + FlangedBearing.flange_thickness do
                [-rail_spacing.x/2, rail_spacing.x/2].each do |x|
                    push FlangedBearing, origin:[x, 0, 0], x:X, y:-Y
                    push Leadscrew, origin:[x,0, -Leadscrew.machined_length]
                    push FlangedBearing, origin:[x, 0, Leadscrew.threaded_length]
                end
            end

            push BottomRetainer
            BottomRetainer.mounting_bolt_holes.each do |center|
                push M5x16Bolt, origin:[center.x, center.y, BottomRetainer.thickness], x:X, y:-Y
                push M5HexNut, origin:[center.x, center.y, -BottomPanel.thickness - M5HexNut.height]
            end
        end
        translate z:-DeckPanel.thickness - TopRetainer.length do
            push TopRetainer
            TopRetainer.bolt_holes.each do |center|
                push M5x16Bolt, origin:[center.x, center.y, 0]
                if center.y < 0
                    push M5HexNut, origin:[center.x, center.y, DeckPanel.thickness + TopRetainer.length]
                end
            end
        end

        translate x:BottomRetainer.motor_belt_length do
            NEMA17.bolt_holes.each do |x,y|
                push M3x60Bolt, origin:[x, y, -rail_length - BottomPanel.thickness]
            end
        end

    end

    # Piston assembly
    push PistonAssembly, origin:[0, 0, DeckPanel.thickness]
end
