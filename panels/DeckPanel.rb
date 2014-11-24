require_relative '../motors/NEMA17'
require_relative '../TopRetainer'

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
    translate FRAME_KLASS.width + 0.5.cm, FRAME_KLASS.width + 0.5.cm do
        circle diameter:5.mm
        rectangle origin:[1.cm, 0], size:[1.cm, 1.mm]
        rectangle origin:[0, 1.cm], size:[1.mm, 1.cm]
    end

    translate piston_cutout_center do
        # X-motor mounting holes
        translate -(RAIL_LENGTH_X + XMotorAndSprocketAssembly.motor_body_width)/2, X_RAIL_BACK_Y + (MakerSlide.width + XMotorAndSprocketAssembly.motor_body_width)/2 - 5.mm do
            NEMA17.bolt_holes.each do |center|
                circle center:center, diameter:NEMA17.bolt_hole_diameter
            end
        end

        # Front X-rail mounting holes
        repeat center:[0, X_RAIL_FRONT_Y], step:[size.x/4, 2.cm], count:[4, 2] do
            circle diameter:5.mm
        end

        # Back X-rail mounting holes
        repeat center:[0, X_RAIL_BACK_Y], step:[size.x/4, 2.cm], count:[4, 2] do
            circle diameter:5.mm
        end

        repeat step:[PISTON_SIZE.x + PLATFORM_SPACING, Z_RAIL_SPACING_Y], count:[2, 2] do
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
