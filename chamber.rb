extrusion :ChamberFrontPanel do
    length ACRYLIC_THICKNESS

    attr_reader size: Size[CHAMBER_BOX.x + 4.cm, CHAMBER_BOX.z - length]

    polygon do
        up      size.y

        right   2.cm
        up      2*length
        right   CHAMBER_BOX.x
        right   TopPanel.dump_slot_width    # Extend the rails to cover the dump slot
        down    2*length
        right_to    size.x

        down    size.y
    end

    # Slots for the piston center wall and piston side walls
    repeat center:[size.x/2, 2.0835.cm], step:[PISTON_SIZE.x + length, 1.667.cm], count:[3,3] do
        rectangle center:[0,0], size:[length, 0.833.cm]
    end

    # Holes for the angle brackets
    circle center:[size.x/2 + CHAMBER_BOX.x/2 + 1.cm, 3.8.cm], diameter:0.4.cm
    circle center:[size.x/2 - (CHAMBER_BOX.x/2 + 1.cm), 3.8.cm], diameter:0.4.cm
end

extrusion :ChamberSidePanel do
    attr_reader size: Size[PLATFORM_SIZE.y + 2*ChamberFrontPanel.length + 0.5.mm, BUILD_VOLUME.z]

    length ACRYLIC_THICKNESS

    tooth_depth = ChamberFrontPanel.length

    polygon do
        start_at    [0,0]
        repeat to:[0, size.y], count:3 do |step|
            forward step/2
            right   tooth_depth
            forward step/2
        end

        right   ACRYLIC_THICKNESS
        up      ACRYLIC_THICKNESS
        right   PLATFORM_SIZE.y + 0.5.mm
        down    ACRYLIC_THICKNESS

        move_to size    # Top edge

        repeat to:[size.x, 0], count:3 do |step|
            right   tooth_depth
            forward step/2
            left   tooth_depth
            forward step/2
        end
    end
end

extrusion :ChamberCenterPanel do
    attr_reader size: Size[PLATFORM_SIZE.y + 2*ChamberFrontPanel.length + 0.5.mm, BUILD_VOLUME.z]

    length ACRYLIC_THICKNESS

    tooth_depth = ChamberFrontPanel.length

    polygon do
        start_at    [0,0]
        repeat to:[0, size.y], count:3 do |step|
            forward step/2
            right   tooth_depth
            forward step/2
        end

        right   ACRYLIC_THICKNESS
        up      ACRYLIC_THICKNESS - 2.mm.cm
        right   PLATFORM_SIZE.y + 0.5.mm
        down    ACRYLIC_THICKNESS - 2.mm.cm

        move_to size    # Top edge

        repeat to:[size.x, 0], count:3 do |step|
            right   tooth_depth
            forward step/2
            left   tooth_depth
            forward step/2
        end
    end
end
