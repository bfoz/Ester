require_relative '../BottomRetainer'

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
        repeat step:[PISTON_SIZE.x + PLATFORM_SPACING, Z_RAIL_SPACING_Y], count:2 do
            # Z-rail retainer plate mounting holes
            BottomRetainer.mounting_bolt_holes.each {|center| circle center:center, diameter:BottomRetainer.mounting_bolt_diameter}

            # Extra bolt holes for putting support rails under the motors
            repeat step:7.cm, count:[1,2] { circle diameter:5.mm }
        end

        repeat step:[2*PISTON_SIZE.x + PLATFORM_SPACING + 6.3.cm, Z_RAIL_SPACING_Y], count:2 do
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
