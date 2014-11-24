require_relative 'PistonAssembly'

extrusion :ChamberSidePanel do
    attr_reader size: Size[PLATFORM_SIZE.y + 2*PISTON_WALL_THICKNESS, CHAMBER_BOX.z.cm + DeckPanel.thickness]

    attr_reader repeat_count: 8
    attr_reader slot_count: (repeat_count + 1)/2
    attr_reader slot_length: (size.y - (1.cm + BottomPanel.thickness))/repeat_count

    length PISTON_WALL_THICKNESS

    tooth_depth = PISTON_WALL_THICKNESS

    polygon do
        start_at    [PISTON_WALL_THICKNESS,0]
        up      1.cm + BottomPanel.thickness

        i = 0
        repeat to:[last.x, size.y], count:repeat_count do |step|
            left   tooth_depth if i.even?
            forward step
            i += 1
        end

        up_to   size.y
        up      DeckPanel.thickness
        right   PLATFORM_SIZE.y
        down    DeckPanel.thickness

        i = 0
        repeat to:[last.x, 1.cm + BottomPanel.thickness], count:repeat_count do |step|
            left   tooth_depth if i.odd?
            forward step
            i += 1
        end

        down_to     0

        repeat to:[tooth_depth, 0], count:2 do |step|
            forward step/4
            right   tooth_depth
            forward step/2
            left    tooth_depth
            forward step/4
        end
    end
end

extrusion :ChamberFrontPanel do
    attr_reader rail_height: ACRYLIC_THICKNESS
    attr_reader size: Size[CHAMBER_BOX.x + 4.cm, CHAMBER_BOX.z]
    attr_reader thickness: PISTON_WALL_THICKNESS

    length thickness

    polygon do
        up      size.y

        right   2.cm
        up      ACRYLIC_THICKNESS + rail_height
        right   CHAMBER_BOX.x
        right   DeckPanel.dump_slot_width    # Extend the rails to cover the dump slot
        down    ACRYLIC_THICKNESS + rail_height
        right_to    size.x

        down    size.y
    end

    # Slots for the piston center wall
    repeat center:[size.x/2, size.y - BUILD_VOLUME.z/2 - 4.165.mm], step:[0, 1.667.cm], count:[1,3] do
        rectangle center:[0,0], size:[length, 0.833.cm]
    end

    # Slots for the piston side walls
    repeat center:[size.x/2, (size.y-rail_height)/2 - 3.375.mm], step:[2*PISTON_SIZE.x + 2*PISTON_WALL_THICKNESS, ChamberSidePanel.slot_length*2], count:[2,ChamberSidePanel.repeat_count/2] do
        rectangle center:[0,0], size:[length, ChamberSidePanel.slot_length]
    end

    # Slots for the belts that connect the front and rear leadscrews
    repeat center:[size.x/2, 2.cm], step:[PISTON_SIZE.x + PISTON_WALL_THICKNESS, 0], count:2 do
        rectangle center:[-Z_RAIL_SPACING/2, 0], size:[3.cm, 1.cm]
    end

    # Cutout for the piston
    piston_slot_height = BUILD_VOLUME.z + PistonAssembly.flange_height
    repeat center:[size.x/2, size.y - PistonAssembly.height + PistonAssembly.flange_height - piston_slot_height/2], step:[BUILD_VOLUME.x + PLATFORM_SPACING, 0], count:[2,1] do
        rectangle center:[0,0], size:[PistonAssembly.bracket_width, piston_slot_height]
    end
end

extrusion :ChamberCenterPanel do
    attr_reader tab_height:DeckPanel.thickness - 2.mm.cm
    attr_reader size: Size[PLATFORM_SIZE.y + 2*ChamberFrontPanel.thickness, BUILD_VOLUME.z]

    length PISTON_WALL_THICKNESS

    tooth_depth = ChamberFrontPanel.length

    polygon do
        start_at    [0,0]
        repeat to:[0, size.y], count:3 do |step|
            forward step/2
            right   tooth_depth
            forward step/2
        end

        right   ChamberFrontPanel.thickness
        up      tab_height
        right   PLATFORM_SIZE.y
        down    tab_height

        move_to size    # Top edge

        repeat to:[size.x, 0], count:3 do |step|
            right   tooth_depth
            forward step/2
            left   tooth_depth
            forward step/2
        end
    end
end
