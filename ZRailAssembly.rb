require_relative 'fasteners'
require_relative 'motors/NEMA17'
require_relative 'panels/BottomPanel'
require_relative 'panels/DeckPanel'
require_relative 'sprockets'

require_relative 'BottomRetainer'
require_relative 'PistonAssembly'
require_relative 'TopRetainer'
require_relative 'ZMotorAssembly'

# TR10x2 Trapezoidal leadscrew
model :Leadscrew do
    attr_reader machined_length: 5.mm                       # The length of the turned ends
    attr_reader threaded_length: PistonAssembly.height + (BUILD_VOLUME.z - TopRetainer.thickness) + 2.cm
    attr_reader length:threaded_length + 2*machined_length  # Overall length (including the turned ends)

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

model :ZRailAssembly do
    attr_reader height: Leadscrew.threaded_length + 2*FlangedBearing.flange_thickness + TopRetainer.thickness + BottomRetainer.thickness
    attr_reader rail_spacing: Size[Z_RAIL_SPACING, PLATFORM_SIZE.y + 7.cm]
    attr_reader motor_center: Point[-Z_RAIL_SPACING/2, rail_spacing.y/2+TopRetainerBack.motor_belt_length]

    # The front side of the assembly
    translate y:-rail_spacing.y/2 do
        # Front-left sprocket (connects to the rear-left sprocket)
        push Sprocket_GT2_36_10mm, origin:[-rail_spacing.x/2, 0, BottomRetainer.thickness + FlangedBearing.flange_thickness + 1.mm]

        translate z:height - ZMotorAssembly.belt_bottom + Sprocket_GT2_36_10mm.belt_bottom do
            # Front-left sprocket
            push Sprocket_GT2_36_10mm, origin:[-rail_spacing.x/2, 0, Sprocket_GT2_36_10mm.length]

            # The front sprockets connecting the two front leadscrews to each other
            translate x:rail_spacing.x/2 do
                push Sprocket_GT2_36_10mm, origin:[0, 0, Sprocket_GT2_36_10mm.length]
            end
        end

        push BottomRetainer
        BottomRetainer.mounting_bolt_holes.each do |center|
            push M5x16Bolt, origin:[center.x, center.y, BottomRetainer.thickness], x:X, y:-Y
            push M5HexNut, origin:[center.x, center.y, -BottomPanel.thickness - M5HexNut.height]
        end

        translate z:BottomRetainer.length + FlangedBearing.flange_thickness do
            [-rail_spacing.x/2, rail_spacing.x/2].each do |x|
                push FlangedBearing, origin:[x, 0, 0], x:X, y:-Y
                push Leadscrew, origin:[x,0, -Leadscrew.machined_length]
                push FlangedBearing, origin:[x, 0, Leadscrew.threaded_length]
            end

            translate z:Leadscrew.threaded_length + FlangedBearing.flange_thickness do
                push TopRetainer
                TopRetainer.bolt_holes.each do |center|
                    push M5x16Bolt, origin:[center.x, center.y, 0]
                    if center.y > 0
                        push M5HexNut, origin:[center.x, center.y, DeckPanel.thickness + TopRetainer.length]
                    end
                end
            end
        end
    end

    # The back side of the assembly
    translate y:rail_spacing.y/2 do
        translate z:height do
            translate -Z_RAIL_SPACING/2, TopRetainerBack.motor_belt_length, 0 do
                push ZMotorAssembly, origin:[0, 0, -TopRetainerBack.thickness], x:-X, y:Y
                NEMA17.bolt_holes.each do |x,y|
                    push M3x60Bolt, origin:[x, y, DeckPanel.thickness], x:X, y:-Y
                end
            end
        end

        # Left-rear sprocket (connects to the front left sprocket)
        translate x:-rail_spacing.x/2, z:BottomRetainer.thickness + FlangedBearing.flange_thickness + 1.mm do
            push Sprocket_GT2_36_10mm
        end

        translate z:height - ZMotorAssembly.belt_bottom + Sprocket_GT2_36_10mm.belt_bottom do
            # Rear-left sprocket that connects to the motor
            push Sprocket_GT2_36_10mm, origin:[-rail_spacing.x/2, 0, -TopRetainerBack.thickness], x:X, y:-Y

            # The rear sprockets connecting the two rear leadscrews to each other
            translate z:Sprocket_GT2_36_10mm.length do
                push Sprocket_GT2_36_10mm, origin:[-rail_spacing.x/2, 0, 0]
                push Sprocket_GT2_36_10mm, origin:[rail_spacing.x/2, 0, 0]
            end
        end

        push BottomRetainer
        BottomRetainer.mounting_bolt_holes.each do |center|
            push M5x16Bolt, origin:[center.x, center.y, BottomRetainer.thickness], x:X, y:-Y
            push M5HexNut, origin:[center.x, center.y, -BottomPanel.thickness - M5HexNut.height]
        end

        translate z:BottomRetainer.length + FlangedBearing.flange_thickness do
            [-rail_spacing.x/2, rail_spacing.x/2].each do |x|
                push FlangedBearing, origin:[x, 0, 0], x:X, y:-Y
                push Leadscrew, origin:[x,0, -Leadscrew.machined_length]
                push FlangedBearing, origin:[x, 0, Leadscrew.threaded_length]
            end

            translate z:Leadscrew.threaded_length + FlangedBearing.flange_thickness do
                push TopRetainerBack
                TopRetainer.bolt_holes.each do |center|
                    push M5x16Bolt, origin:[center.x, center.y, 0]
                    if center.y < 0
                        push M5HexNut, origin:[center.x, center.y, DeckPanel.thickness + TopRetainer.length]
                    end
                end
            end
        end
    end

    # Piston assembly
    push PistonAssembly, origin:[0, 0, height + DeckPanel.thickness]
end
