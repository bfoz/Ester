require_relative 'enclosure'    # For DeckPanel
require_relative 'sprockets'

require_relative 'TopRetainer'

# The distance between the leadscrew pulley and the motor pulley
# Assuming 2mm pitch GT2 belt...
# distance = (Belt_teeth - Pulley_teeth)
PULLEY_SPACING = (101 - 20).mm + 1.mm   # Add 1mm for tensioning

# TR10x2 Trapezoidal leadscrew
extrusion :Leadscrew do
    circle diameter:10.mm
end

extrusion :ZCarriagePanel do
    attr_reader height: 4.cm
    attr_reader width: PLATFORM_BRACKET_SPACING + ACRYLIC_THICKNESS

    length ACRYLIC_THICKNESS

    repeat_count = 3
    attr_reader slot_count: (repeat_count + 1)/2
    attr_reader slot_length: height/repeat_count
    attr_reader slot_spacing: 2*height/repeat_count

    polygon do
        start_at    [-width/2, -height/2]

        i = 0
        repeat to:[last.x, last.y + height], count:repeat_count do |step|
            right length if i.odd?
            forward step
            i = i + 1
        end

        right       width

        i = 0
        repeat to:[last.x, last.y - height], count:repeat_count do |step|
            right length if i.odd?
            forward step
            i = i + 1
        end
    end

    # Pas-thrus for the leadscrews
    repeat step:[Z_RAIL_SPACING, 0], count:[2,1] do
        circle diameter:10.5.mm
    end
end

extrusion :PlatformBracketBoxPanel do
    attr_reader height: 5.5.cm
    attr_reader width: PLATFORM_BRACKET_SPACING + ACRYLIC_THICKNESS
    attr_reader repeat_count: 5
    attr_reader slot_count: (repeat_count + 1)/2
    attr_reader slot_length: height/repeat_count

    length ACRYLIC_THICKNESS

    polygon do
        start_at    [-width/2, -height/2]

        i = 0
        repeat to:[last.x, last.y + height], count:repeat_count do |step|
            right length if i.odd?
            forward step
            i = i+1
        end

        right       width

        i = 0
        repeat to:[last.x, last.y - height], count:repeat_count do |step|
            right length if i.odd?
            forward step
            i = i+1
        end
    end
end

extrusion :PistonBoxBottomPanel do
    length ACRYLIC_THICKNESS

    attr_reader height: 20.cm
    attr_reader width: PLATFORM_BRACKET_SPACING + length

    attr_reader repeat_count: 10
    attr_reader slot_count: (repeat_count + 1)/2
    attr_reader slot_length: height/repeat_count

    polygon do
        start_at    [-width/2, -height/2]

        i = 0
        repeat to:[last.x, last.y + height], count:repeat_count do |step|
            right length if i.even?
            forward step
            i = i+1
        end

        right       width

        i = 0
        repeat to:[last.x, last.y - height], count:repeat_count do |step|
            right length if i.odd?
            forward step
            i = i+1
        end
    end

    # Pas-thrus for the leadscrews
    repeat step:[Z_RAIL_SPACING, 16.cm], count:[2, 2] do
        circle diameter:10.5.mm
    end
end

extrusion :PlatformBracket do
    attr_reader thickness: ACRYLIC_THICKNESS
    attr_reader width: PLATFORM_SIZE.y
    attr_reader flange_height: 3.cm
    attr_reader platform_width: PLATFORM_SIZE.y
    attr_reader slot_height: 1.6.cm
    attr_reader slot_width: 1.cm
    attr_reader flange_length: slot_width + ZCarriagePanel.height

    attr_reader height: BUILD_VOLUME.z + flange_height

    attr_reader carriage_panel_offsets: repeat(center:[platform_width/2, PillowBlock.length + 1.5*ZCarriagePanel.length - height], step:[platform_width+6.cm, 0], count:[2,1])
    attr_reader box_panel_offsets: repeat(center:[platform_width/2, 4.25.cm - height], spacing:[8.52.cm, 2.2.cm], count:[2, 1])

    platform_inset = 1.mm
    platform_tab_length = 3.cm

    length thickness
    polygon origin:[platform_inset, 0] do
        right       (platform_width - platform_tab_length)/2 - platform_inset
        move_y      ACRYLIC_THICKNESS
        move_x      platform_tab_length
        move_y      -ACRYLIC_THICKNESS
        right_to    width - 2*platform_inset

        down        height - flange_height
        right       platform_inset
        right       slot_width
        up          slot_height
        right       flange_length - slot_width
        down        slot_height
        down        flange_height

        i = 0
        repeat step:[-PistonBoxBottomPanel.slot_length, 0], count:PistonBoxBottomPanel.repeat_count do |step|
            right PistonBoxBottomPanel.length if i.even?
            forward step
            i = i + 1
        end

        left_to     -platform_inset
        left        flange_length

        up          flange_height
        up          slot_height

        right       flange_length - slot_width
        down        slot_height
        right       slot_width + platform_inset
    end

    # Slots for the carriage panel
    carriage_panel_offsets.each do |offset|
        repeat center:offset, step:[ZCarriagePanel.slot_spacing, 0], count:[ZCarriagePanel.slot_count,1] do
            rectangle center:[0, 0], size:[-ZCarriagePanel.slot_length, ZCarriagePanel.length]
        end
    end

    translate 0, -height do     # Start at the bottom
        platform_center_x = platform_width/2

        # Slots for box panels
        repeat center:[platform_center_x, 4.25.cm], spacing:[8.52.cm, 2.2.cm], count:[2, PlatformBracketBoxPanel.slot_count] do
            rectangle center:[0,0], size:[PlatformBracketBoxPanel.length, PlatformBracketBoxPanel.slot_length]
        end

        # Clearance holes for the pillow block bolts
        repeat center:[platform_center_x, PistonBoxBottomPanel.length + PillowBlock.length/2], step:[platform_width + 6.cm, 0], count:[2,1] do
            repeat spacing:[24.mm, 18.mm], count:2 do
                circle diameter:4.mm
            end
        end
    end
end

extrusion :PlatformPanel do
    attr_reader size: PLATFORM_SIZE.inset(0.1.mm)

    length ACRYLIC_THICKNESS
    rectangle center:[0,0], size:size
    repeat step:PLATFORM_BRACKET_SPACING, count:2 do
        rectangle center:[0,0], size:[PlatformBracket.thickness, 3.cm]
    end
end

model :ZCarriageAssembly do
    push ZCarriagePanel
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
                push Leadscrew, origin:[x,0,0], length:rail_length - DeckPanel.length
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
                push Leadscrew, origin:[x,0,0], length:rail_length - DeckPanel.length
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
    group origin:[0, 0, 0] do
        translate 0, 0, -DeckPanel.thickness do
            push PlatformPanel

            translate 0, -PlatformPanel.size.y/2, 0 do
                # Brackets
                [-PLATFORM_BRACKET_SPACING/2, PLATFORM_BRACKET_SPACING/2].each do |x|
                    push PlatformBracket, origin: [x - PlatformBracket.length/2, 0, 0], x:Y, y:Z
                end

                PlatformBracket.carriage_panel_offsets.each do |offset|
                    push ZCarriageAssembly, origin:[0, offset.x, offset.y - ZCarriagePanel.length/2]
                end

                PlatformBracket.box_panel_offsets.each do |origin|
                    push PlatformBracketBoxPanel, origin:[0, origin.x + PlatformBracketBoxPanel.length/2, origin.y], x:X, y:Z
                end
            end

            push PistonBoxBottomPanel, origin:[0, 0, -PlatformBracket.height]
        end

        [-motor_group_y, motor_group_y].each do |y|
            translate 0, y, -PlatformBracket.height - 0.8.mm do
                [-Z_RAIL_SPACING/2, Z_RAIL_SPACING/2].each do |x|
                    push PillowBlock, origin:[x, 0, 0.8.mm], x:Y, y:-X
                end
            end
        end
    end
end
