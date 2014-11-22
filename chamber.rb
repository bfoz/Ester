require_relative 'PistonAssembly'

extrusion :ChamberFrontPanel do
    attr_reader rail_height: ACRYLIC_THICKNESS
    attr_reader size: Size[CHAMBER_BOX.x + 4.cm, CHAMBER_BOX.z]
    attr_reader thickness: PISTON_WALL_THICKNESS

    length thickness

    polygon do
        up      size.y - ACRYLIC_THICKNESS

        right   2.cm
        up      ACRYLIC_THICKNESS + rail_height
        right   CHAMBER_BOX.x
        right   DeckPanel.dump_slot_width    # Extend the rails to cover the dump slot
        down    ACRYLIC_THICKNESS + rail_height
        right_to    size.x

        down    size.y - ACRYLIC_THICKNESS
    end

    # Slots for the piston center wall
    repeat center:[size.x/2, size.y - BUILD_VOLUME.z/2 - 4.169.mm - ACRYLIC_THICKNESS], step:[0, 1.667.cm], count:[1,3] do
        rectangle center:[0,0], size:[length, 0.833.cm]
    end

    # Slots for the piston side walls
    repeat center:[size.x/2, (size.y-ACRYLIC_THICKNESS)/2 - 6.5.mm], step:[2*PISTON_SIZE.x + 2*PISTON_WALL_THICKNESS, 4.6.cm], count:[2,4] do
        rectangle center:[0,0], size:[length, 2.3.cm]
    end

    # Cutout for the piston
    piston_slot_height = BUILD_VOLUME.z + PistonAssembly.flange_height
    repeat center:[size.x/2, size.y - BUILD_VOLUME.z - piston_slot_height/2], step:[BUILD_VOLUME.x + PLATFORM_SPACING, 0], count:[2,1] do
        rectangle center:[0,0], size:[PistonAssembly.bracket_width, piston_slot_height]
    end
end

extrusion :ChamberSidePanel do
    attr_reader size: Size[PLATFORM_SIZE.y + 2*ChamberFrontPanel.thickness, CHAMBER_BOX.z]

    length PISTON_WALL_THICKNESS

    tooth_depth = ChamberFrontPanel.length

    polygon do
        start_at    [PISTON_WALL_THICKNESS,0]
        up      1.cm + ACRYLIC_THICKNESS
        repeat to:[last.x, size.y], count:4 do |step|
            left   tooth_depth
            forward step/2
            right   tooth_depth
            forward step/2
        end

        up_to   size.y
        # right   ACRYLIC_THICKNESS
        up      ACRYLIC_THICKNESS
        right   PLATFORM_SIZE.y
        down    ACRYLIC_THICKNESS

        # move_to size    # Top edge

        repeat to:[last.x, 1.cm + ACRYLIC_THICKNESS], count:4 do |step|
            forward step/2
            left   tooth_depth
            forward step/2
            right   tooth_depth
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

extrusion :ChamberCenterPanel do
    attr_reader top_panel_thickness: ACRYLIC_THICKNESS
    attr_reader tab_height:top_panel_thickness - 2.mm.cm
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

        right   ChamberFrontPanel.length
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
