require 'engineering'
require 'fasteners'

require_relative 'frame/TSlot20x20'
require_relative 'MakerSlide'
require_relative 'MotorAndPulleyAssembly'
require_relative 'PillowBlock'

# The build platform is +x, +y
# The hopper platform is -x, +y
# The +y direction is away from the z-rails
# The y-origin is between the platforms
# +z is up (the build platform moves -z as the build progresses)

PISTON_SIZE = Size[10.cm, 10.cm]

FRAME_KLASS = TSlot20x20

DECK_BORDER_LEFT = 10.cm
DECK_BORDER_BOTTOM = 5.cm + MakerSlide.width + FRAME_KLASS.width
DECK_BORDER_RIGHT = 10.cm
DECK_BORDER_TOP = 7.cm + MakerSlide.width + FRAME_KLASS.width

ACRYLIC_THICKNESS = 6.mm.cm    # The acrylic panels sold at the TechShop are 6mm thick
PANEL_THICKNESS = 5.2.mm.cm
ENCLOSURE_THICKNESS = 3.mm.cm   # 1/8"
PISTON_WALL_THICKNESS = ACRYLIC_THICKNESS

PLATFORM_SIZE = Size[10.cm, 10.cm]
DUMP_SLOT_WIDTH = 1.cm

RAIL_LENGTH_X = 37.5.cm
RAIL_LENGTH_Y = 20.cm
BUILD_VOLUME = Size[10.cm, 10.cm, 5.cm]
Z_CARRIAGE_HEIGHT = 6.cm

Z_LEADSCREW_LENGTH = 10.cm
Z_RAIL_LENGTH = 200.mm.cm
Z_RAIL_SPACING = 6.cm

ENCLOSURE_FRAME_WIDTH = 2.cm
PLATFORM_BRACKET_SPACING = Z_RAIL_SPACING + PillowBlock.height + ACRYLIC_THICKNESS

LEFT_DECK_BORDER_WIDTH = 10.cm
ENCLOSURE_LEFT_X = -(LEFT_DECK_BORDER_WIDTH + PLATFORM_SIZE.x/2)

END_ZONE_LENGTH = 10.cm
UPPER_ENCLOSURE_HEIGHT = 15.cm

PLATFORM_SPACING = PISTON_WALL_THICKNESS 	# The gap between the two platforms
PLATFORM_CUTOUT_SIZE = Size[2*PISTON_SIZE.x + PLATFORM_SPACING + 2*PISTON_WALL_THICKNESS + DUMP_SLOT_WIDTH, PISTON_SIZE.y + 2*PISTON_WALL_THICKNESS]
PLATFORM_CUTOUT_CENTER = Point[Size[DECK_BORDER_LEFT, DECK_BORDER_BOTTOM] + PLATFORM_CUTOUT_SIZE/2]

RAIL_POSITION_X = PLATFORM_CUTOUT_SIZE.y/2 + 5.cm
X_RAIL_BACK_Y = RAIL_POSITION_X
X_RAIL_FRONT_Y = -RAIL_POSITION_X
X_RAIL_SPACING = X_RAIL_BACK_Y - X_RAIL_FRONT_Y

DECK_SIZE = PLATFORM_CUTOUT_SIZE.outset(top: DECK_BORDER_TOP,
                                        left: DECK_BORDER_LEFT,
                                        bottom: DECK_BORDER_BOTTOM,
                                        right: DECK_BORDER_RIGHT)

CHAMBER_BOX = Size[PLATFORM_CUTOUT_SIZE.x, PLATFORM_CUTOUT_SIZE.y, Z_RAIL_LENGTH]

INTERIOR_DIMENSIONS = Size[CHAMBER_BOX.x + END_ZONE_LENGTH, 40.cm, 40.cm]

X = Vector::X
Y = Vector::Y
Z = Vector::Z

require_relative 'frame/ExtrusionBracket'

require_relative 'enclosure'
require_relative 'XCarriageAssembly'
require_relative 'ZRailAssembly'
require_relative 'VWheelAssembly'

require_relative 'chamber'

extrusion :EndstopPlate do
    length ACRYLIC_THICKNESS

    rectangle center:[0,0], size:[2.cm, 4.cm]

    # Bolt hole for attaching to the MakerSlide
    circle center:[0, 1.cm], diameter:5.mm

    # Bolt holes for attaching the limit switch
    repeat center:[0, -1.cm], spacing:9.5.mm, count:[1,2] do
        circle diameter:3.mm
    end
end

model :Ester do
    translate [0, 0, 1.cm] do
        translate [-RAIL_LENGTH_X/2, 0, 0] do
            push MakerSlide, length:RAIL_LENGTH_X, origin:[RAIL_LENGTH_X, X_RAIL_BACK_Y, 0], x:-Y, y:Z
            push MakerSlide, length:RAIL_LENGTH_X, origin:[0, X_RAIL_FRONT_Y, 0], x:Y, y:Z
        end

        translate [0, 0, 1.cm] do
            push EndstopPlate, origin:[-RAIL_LENGTH_X/2 + 1.5.cm, X_RAIL_BACK_Y, 0]
        end

        push XCarriageAssembly, origin:[0, 0, 2.75.cm/2 + PrecisionShim.length + 1.8.mm.cm]
    end

    # Z-rail Assembly group
    group origin:[0, 0, 0] do
        push ZRailAssembly, origin:[-(PLATFORM_SIZE.x + PLATFORM_SPACING)/2, 0, 0], x:-X, y:-Y
        push ZRailAssembly, origin:[(PLATFORM_SIZE.x + PLATFORM_SPACING)/2, 0, 0]
    end

    # Extrusion frame
    translate 0, (DECK_BORDER_TOP - DECK_BORDER_BOTTOM)/2, -ACRYLIC_THICKNESS do
        frame_size = Size[DECK_SIZE.x, DECK_SIZE.y, Z_RAIL_LENGTH + FRAME_KLASS.height]
        frame_spacing = Size[frame_size.x - FRAME_KLASS.width, frame_size.y - FRAME_KLASS.width, frame_size.z]
        frame_length = Size[frame_spacing.x - FRAME_KLASS.width, frame_spacing.y - FRAME_KLASS.width, frame_size.z]

        x_coordinates = [-frame_spacing.x/2, frame_spacing.x/2]
        y_coordinates = [-frame_spacing.y/2, frame_spacing.y/2]
        z_coordinates = [-frame_size.z + FRAME_KLASS.height/2, -FRAME_KLASS.height/2, UPPER_ENCLOSURE_HEIGHT - FRAME_KLASS.height/2]

        # Vertical supports
        x_coordinates.product(y_coordinates) do |x,y|
            push FRAME_KLASS, length:frame_length.z + UPPER_ENCLOSURE_HEIGHT, origin:[x, y, -frame_size.z]
        end

        # The front and back rails
        y_coordinates.product(z_coordinates) do |y,z|
            push FRAME_KLASS, length:frame_length.x, origin:[x_coordinates.first + FRAME_KLASS.width/2, y, z], x:-Z, y:Y
        end

        # The side and center rails
        x_coordinates.product(z_coordinates) do |x, z|
            push FRAME_KLASS, length:frame_length.y, origin:[x, frame_length.y/2, z], x:-Z, y:X
        end

        # Corner brackets
        bracket_z = [[-FRAME_KLASS.height, 1],
                     [-frame_size.z + FRAME_KLASS.height + DeckPanel.length, -1],
                     [ UPPER_ENCLOSURE_HEIGHT - FRAME_KLASS.height, 1]]
        x_coordinates.product(y_coordinates).product(bracket_z) do |(x,y),(z,sign)|
            half_width = FRAME_KLASS.width/2
            translate x, y, z do
                x_sign = (x <=> 0)
                y_sign = (y <=> 0)

                # The brackets on the short sides
                push ExtrusionBracket, origin:[0, -y_sign*half_width, 0], x:-sign*Z, y:y_sign*sign*X
                push M5x12Bolt, origin:[0, -y_sign*(half_width + 5.mm), -sign*25.mm], x:X, y:-y_sign*Z
                push M5x16Bolt, origin:[0, -y_sign*(half_width + 25.mm), -sign*5.mm], x:X, y:sign*Y

                # The brackets on the long sides
                push ExtrusionBracket, origin:[-x_sign*half_width, 0, 0], x:-sign*Z, y:-x_sign*sign*Y
                push M5x12Bolt, origin:[-x_sign*(half_width + 5.mm), 0, -sign*25.mm], x:-x_sign*Z, y:Y
                push M5x16Bolt, origin:[-x_sign*(half_width + 25.mm), 0, -sign*5.mm], x:X, y:sign*Y
            end
        end
    end

    # Enclosure
    translate -DeckPanel.piston_cutout_center do
        push TopPanel, origin:[0, 0, UPPER_ENCLOSURE_HEIGHT - DeckPanel.thickness]
        translate 0, 0, -DeckPanel.thickness do
            push DeckPanel
        end

        translate 0, 0, -Z_RAIL_LENGTH - BottomPanel.thickness do
            push BottomPanel

            translate 0, 0, -FRAME_KLASS.height do
                push EnclosureFrontPanel, origin:[0, 0, 0], x:X, y:Z
                push EnclosureFrontPanel, origin:[0, DECK_SIZE.y + EnclosureFrontPanel.thickness, 0], x:X, y:Z

                push EnclosureSidePanel, origin:[0, DECK_SIZE.y, 0], x:-Y, y:Z
                push EnclosureSidePanel, origin:[DECK_SIZE.x, 0, 0], x:Y, y:Z
            end
        end

        # Top deck attachment bolts
        DeckPanel.side_bolt_holes.each do |center|
            push FlatWasher, origin:[*center, 0]
            push M5x12Bolt, origin:[*center, FlatWasher.length], x:X, y:-Y
        end
        DeckPanel.front_bolt_holes.each do |center|
            push FlatWasher, origin:[*center, 0]
            push M5x12Bolt, origin:[*center, FlatWasher.length], x:X, y:-Y
        end

        # Bottom deck attachment bolts
        translate 0, 0, -Z_RAIL_LENGTH - BottomPanel.length + DeckPanel.length do
            # Ignore the holes that are for the corner brackets. Those bolts are handled elsewhere.
            min, max = BottomPanel.side_bolt_holes.minmax_by(&:y)
            BottomPanel.side_bolt_holes.each do |center|
                next if  (center.y == min.y) || (center.y == max.y)
                push FlatWasher, origin:[*center, 0]
                push M5x12Bolt, origin:[*center, FlatWasher.length], x:X, y:-Y
            end
            min, max = BottomPanel.front_bolt_holes.minmax_by {|point| point.x}
            BottomPanel.front_bolt_holes.each do |center|
                next if  (center.x == min.x) || (center.x == max.x)
                push FlatWasher, origin:[*center, 0]
                push M5x12Bolt, origin:[*center, FlatWasher.length], x:X, y:-Y
            end
        end
    end

    # Piston walls
    translate 0, 0, -DeckPanel.thickness do
        translate 0, PISTON_WALL_THICKNESS/2, DeckPanel.thickness-ChamberFrontPanel.size.y do
            seperation = (CHAMBER_BOX.y - PISTON_WALL_THICKNESS)/2
            push ChamberFrontPanel, origin:[-ChamberFrontPanel.size.x/2, seperation, 0], x:X, y:Z
            push ChamberFrontPanel, origin:[-ChamberFrontPanel.size.x/2, -seperation, 0], x:X, y:Z
        end
        translate 0, -ChamberSidePanel.size.x/2, -ChamberSidePanel.size.y do
            push ChamberSidePanel, origin:[-(PLATFORM_SIZE.x + PLATFORM_SPACING/2 + ChamberSidePanel.length), 0, 0], x:Y, y:Z     # Left
            push ChamberSidePanel, origin:[PLATFORM_SIZE.x + PLATFORM_SPACING/2, 0, 0], x:Y, y:Z     # Right
        end
        push ChamberCenterPanel, origin:[-ChamberCenterPanel.length/2, -ChamberCenterPanel.size.x/2, -BUILD_VOLUME.z],  x:Y, y:Z     # Center
    end
end
