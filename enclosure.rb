require_relative 'motors/NEMA17'

require_relative 'TopRetainer'

ENCLOSURE_BOX = Size[DECK_SIZE.x, DECK_SIZE.y, Z_RAIL_LENGTH + FRAME_KLASS.height + UPPER_ENCLOSURE_HEIGHT]

extrusion :EnclosureFrontPanel do
    # !@attribute [r] thickness
    #   @return [Number]    the panel thickness (same as the extrusion length)
    attr_reader thickness: ENCLOSURE_THICKNESS

    attr_reader size: Size[ENCLOSURE_BOX.x, ENCLOSURE_BOX.z]

    length thickness
    rectangle size: size

    # Orientation marker
    translate FRAME_KLASS.width/2, FRAME_KLASS.width/2 do
        circle diameter:5.mm
        rectangle origin:[1.cm, 0], size:[1.cm, 1.mm]
        rectangle origin:[0, 1.cm], size:[1.mm, 1.cm]
    end
end

extrusion :EnclosureSidePanel do
    # !@attribute [r] thickness
    #   @return [Number]    the panel thickness (same as the extrusion length)
    attr_reader thickness: ENCLOSURE_THICKNESS

    attr_reader size: Size[ENCLOSURE_BOX.y, ENCLOSURE_BOX.z]

    length thickness
    rectangle size: size

    # Orientation marker
    translate FRAME_KLASS.width/2, FRAME_KLASS.width/2 do
        circle diameter:5.mm
        rectangle origin:[1.cm, 0], size:[1.cm, 1.mm]
        rectangle origin:[0, 1.cm], size:[1.mm, 1.cm]
    end
end

extrusion :TopPanel do
    # !@attribute [r] thickness
    #   @return [Number]    the panel thickness (same as the extrusion length)
    attr_reader thickness: ENCLOSURE_THICKNESS

    size = DECK_SIZE

    length thickness
    rectangle size: DECK_SIZE

    # Orientation marker
    translate FRAME_KLASS.width/2, FRAME_KLASS.width/2 do
        circle diameter:5.mm
        rectangle origin:[1.cm, 0], size:[1.cm, 1.mm]
        rectangle origin:[0, 1.cm], size:[1.mm, 1.cm]
    end
end

extrusion :DeckPanel do
    # !@attribute [r] dump_slot_width
    #  @return [Number] the width of the hole for the dump slot
    attr_reader dump_slot_width: 1.cm

    # !@attribute [r] piston_cutout_size
    #  @return [Number]   the size of the cutout for the pistons
    attr_reader piston_cutout_size: PLATFORM_CUTOUT_SIZE

    # !@attribute [r] platform_cutout_center
    #  @return [Number] the center of the platform cutout
    attr_reader piston_cutout_center: PLATFORM_CUTOUT_CENTER
    
    # !@attribute [r] thickness
    #   @return [Number]    the panel thickness (same as the extrusion length)
    attr_reader thickness: ACRYLIC_THICKNESS

    s = DECK_SIZE.inset(FRAME_KLASS.width/2, 10.cm)
    attr_reader side_bolt_holes: repeat(center:[DECK_SIZE.x/2, piston_cutout_center.y], step:[s.x, 12.cm], count:[2,2])

    s = DECK_SIZE.inset(FRAME_KLASS.width + 2.5.cm, FRAME_KLASS.width/2)
    attr_reader front_bolt_holes: repeat(center:DECK_SIZE/2, step:[s.x/3, s.y], count:[4,2])

    size = DECK_SIZE

    length thickness
    rectangle size: DECK_SIZE

    # Notch the corners
    repeat center:size/2, step:DECK_SIZE - Size[FRAME_KLASS.width, FRAME_KLASS.height], count:2 do
        rectangle center:[0,0], size:[FRAME_KLASS.width, FRAME_KLASS.height]
    end

    rectangle center:piston_cutout_center + Point[dump_slot_width/2, 0],
                size:piston_cutout_size + Size[dump_slot_width, 0]

    # Orientation marker
    translate FRAME_KLASS.width/2, FRAME_KLASS.width/2 do
        circle diameter:5.mm
        rectangle origin:[1.cm, 0], size:[1.cm, 1.mm]
        rectangle origin:[0, 1.cm], size:[1.mm, 1.cm]
    end

    translate piston_cutout_center do
        # Front X-rail mounting holes
        repeat center:[0, X_RAIL_FRONT_Y], step:[size.x/4, 2.cm], count:[4, 2] do
            circle diameter:5.mm
        end

        # Back X-rail mounting holes
        repeat center:[0, X_RAIL_BACK_Y], step:[size.x/4, 2.cm], count:[4, 2] do
            circle diameter:5.mm
        end

        repeat step:[PISTON_SIZE.x + PLATFORM_SPACING, piston_cutout_size.y + 4.8.cm], count:[2, 2] do
            # Z-rail press-fit holes
            TopRetainer.bearing_holes.each {|center| circle center:center, diameter:9.9.mm}

            # Bolt holes for the Z-axis top retainer plates
            TopRetainer.bolt_holes.each {|center| circle center:center, diameter:TopRetainer.bolt_hole_diameter}
        end

        # Rastered center-line
        repeat spacing:[0, piston_cutout_size.y + 3.cm], count:2 do
            rectangle center:[0, 0], size:[2.mm, 2.cm]
        end
        repeat spacing:[piston_cutout_size.x + 5.cm, 0], count:2 do
            rectangle center:[0, 0], size:[2.cm, 2.mm]
        end
    end

    # Bolt holes for attaching to the side rails
    side_bolt_holes.each {|center| circle center:center, diameter:5.mm.cm }

    # Bolt holes for the front and back rails
    front_bolt_holes.each {|center| circle center:center, diameter:5.mm.cm }
end

extrusion :BottomPanel do
    # !@attribute [r] platform_spacing
    #  @return [Number]   the gap between the two platforms
    attr_reader piston_cutout_size: PLATFORM_CUTOUT_SIZE

    # !@attribute [r] platform_cutout_center
    #  @return [Number] the center of the platform cutout
    attr_reader piston_cutout_center: Size[PLATFORM_CUTOUT_CENTER.x, PLATFORM_CUTOUT_CENTER.y]

    # !@attribute [r] thickness
    #   @return [Number]    the panel thickness (same as the extrusion length)
    attr_reader thickness: ACRYLIC_THICKNESS

    s = DECK_SIZE.inset(FRAME_KLASS.width/2, FRAME_KLASS.width + 2.5.cm)
    attr_reader side_bolt_holes: repeat(center:DECK_SIZE/2, step:[s.x, s.y/2], count:[2,3])

    s = DECK_SIZE.inset(FRAME_KLASS.width + 2.5.cm, FRAME_KLASS.width/2)
    attr_reader front_bolt_holes: repeat(center:DECK_SIZE/2, step:[s.x/3, s.y], count:[4,2])

    size = DECK_SIZE

    length thickness
    rectangle size: DECK_SIZE

    # Notch the corners
    repeat center:size/2, step:DECK_SIZE - Size[FRAME_KLASS.width, FRAME_KLASS.height], count:2 do
        rectangle center:[0,0], size:[FRAME_KLASS.width, FRAME_KLASS.height]
    end

    # Orientation marker
    translate FRAME_KLASS.width + 0.5.cm, FRAME_KLASS.width + 0.5.cm do
        circle diameter:5.mm
        rectangle center:[1.cm, 0], size:[1.cm, 1.mm]
        rectangle center:[0, 1.cm], size:[1.mm, 1.cm]
    end

    translate piston_cutout_center do
        repeat step:[PISTON_SIZE.x + PLATFORM_SPACING, piston_cutout_size.y + 4.8.cm], count:2 do
            # Z-rail retainer plate mounting holes
            repeat step:[Z_RAIL_SPACING, 3.cm], count:2 do
                circle diameter:5.mm
            end

            # Extra bolt holes for putting support rails under the motors
            repeat step:7.cm, count:[1,2] { circle diameter:5.mm }
        end

        repeat step:[2*PISTON_SIZE.x + PLATFORM_SPACING + 6.3.cm, piston_cutout_size.y + 4.8.cm], count:2 do
            # Motor mounting holes
            NEMA17.bolt_holes.each do |x,y|
                circle center:[x, y], diameter:NEMA17.bolt_hole_diameter.cm
            end
        end

        # Slots for the chamber side wall tabs
        repeat step:[2*(PISTON_SIZE.x + PISTON_WALL_THICKNESS), 0], count:2 do
            rectangle center:[0, 43.75.mm], size:[PISTON_WALL_THICKNESS, 1.25.cm]
            rectangle center:[0,0], size:[PISTON_WALL_THICKNESS, 2.5.cm]
            rectangle center:[0, -43.75.mm], size:[PISTON_WALL_THICKNESS, 1.25.cm]
        end
    end

    # Bolt holes for attaching to the side rails
    side_bolt_holes.each {|center| circle center:center, diameter:5.mm.cm }

    # Bolt holes for the front, center, and back rails
    front_bolt_holes.each {|center| circle center:center, diameter:5.mm.cm }
end

extrusion :BackPanel do
    length PANEL_THICKNESS
    size = Size[12.cm, Z_RAIL_LENGTH + FRAME_KLASS.width]

    rectangle size:size

    # Bolt holes for mounting to the frame
    repeat center:size/2, step:size.inset(2.cm, FRAME_KLASS.width/2), count:2 do
        circle diameter:5.mm
    end

    # Motor driver board mounting holes
    repeat center:[size.x/2, 15.cm], step:10.cm, count:[2,2] do
        circle diameter:3.mm.cm
    end

    # Laser driver board mounting holes
    repeat center:[size.x/2, 5.5.cm], step:[67.75.mm, 72.75.mm], count:2 do
        circle diameter:2.5.mm
    end
end
