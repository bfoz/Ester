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

DECK_BORDER_LEFT = 6.975.cm
DECK_BORDER_BOTTOM = 3.cm + MakerSlide.width + FRAME_KLASS.width
DECK_BORDER_RIGHT = 8.cm - 0.275.cm
DECK_BORDER_TOP = 5.cm + MakerSlide.width + FRAME_KLASS.width

ACRYLIC_THICKNESS = 6.mm.cm    # The acrylic panels sold at the TechShop are 6mm thick
PANEL_THICKNESS = 5.2.mm.cm
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

PLATFORM_SPACING = ACRYLIC_THICKNESS 	# The gap between the two platforms
PLATFORM_CUTOUT_SIZE = Size[2*PISTON_SIZE.x + PLATFORM_SPACING + 2*ACRYLIC_THICKNESS + DUMP_SLOT_WIDTH, PISTON_SIZE.y + 2*ACRYLIC_THICKNESS]
PLATFORM_CUTOUT_CENTER = Point[Size[DECK_BORDER_LEFT, DECK_BORDER_BOTTOM] + PLATFORM_CUTOUT_SIZE/2]

RAIL_POSITION_X = PLATFORM_CUTOUT_SIZE.y/2 + 5.cm
X_RAIL_BACK_Y = RAIL_POSITION_X
X_RAIL_FRONT_Y = -RAIL_POSITION_X
X_RAIL_SPACING = X_RAIL_BACK_Y - X_RAIL_FRONT_Y

DECK_SIZE = PLATFORM_CUTOUT_SIZE.outset(top: DECK_BORDER_TOP,
                                        left: DECK_BORDER_LEFT,
                                        bottom: DECK_BORDER_BOTTOM,
                                        right: DECK_BORDER_RIGHT)

CHAMBER_BOX = Size[PLATFORM_CUTOUT_SIZE.x, PLATFORM_CUTOUT_SIZE.y, BUILD_VOLUME.z + ACRYLIC_THICKNESS]

INTERIOR_DIMENSIONS = Size[CHAMBER_BOX.x + END_ZONE_LENGTH, 40.cm, 40.cm]

X = Vector::X
Y = Vector::Y
Z = Vector::Z

require_relative 'frame/ExtrusionBracket'

require_relative 'enclosure'
require_relative 'XCarriageAssembly'
require_relative 'leadscrew'
require_relative 'ZRailAssembly'
require_relative 'LBracket'
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
        translate [-TopPanel.piston_cutout_center.x, 0, 0] do
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
    translate 0.375.cm, (DECK_BORDER_TOP - DECK_BORDER_BOTTOM)/2, -ACRYLIC_THICKNESS do
        upper_height = 15.cm
        frame_size = Size[DECK_SIZE.x, DECK_SIZE.y, Z_RAIL_LENGTH + FRAME_KLASS.height]
        frame_spacing = Size[frame_size.x - FRAME_KLASS.width, frame_size.y - FRAME_KLASS.width, frame_size.z]
        frame_length = Size[frame_spacing.x - FRAME_KLASS.width, frame_spacing.y - FRAME_KLASS.width, frame_size.z]

        x_coordinates = [-frame_spacing.x/2, frame_spacing.x/2]
        y_coordinates = [-frame_spacing.y/2, frame_spacing.y/2]
        z_coordinates = [-frame_size.z + FRAME_KLASS.height/2, -FRAME_KLASS.height/2, upper_height - FRAME_KLASS.height/2]

        # Vertical supports
        x_coordinates.product(y_coordinates) do |x,y|
            push FRAME_KLASS, length:frame_length.z + upper_height, origin:[x, y, -frame_size.z]
        end

        # The front and back rails
        y_coordinates.product(z_coordinates) do |y,z|
            push FRAME_KLASS, length:frame_length.x, origin:[x_coordinates.first + FRAME_KLASS.width/2, y, z], x:-Z, y:Y
        end

        # The side and center rails
        x_coordinates.product(z_coordinates) do |x, z|
            push FRAME_KLASS, length:frame_length.y, origin:[x, frame_length.y/2, z], x:-Z, y:X
        end
        push FRAME_KLASS, length:frame_length.y, origin:[0, frame_length.y/2, z_coordinates.first], x:-Z, y:X

        # Corner brackets
        bracket_z = [[-FRAME_KLASS.height, 1],
                     [-frame_size.z + FRAME_KLASS.height + TopPanel.length, -1],
                     [ upper_height - FRAME_KLASS.height, 1]]
        x_coordinates.product(y_coordinates).product(bracket_z) do |(x,y),(z,sign)|
            translate x, y, z do
                if y > 0
                    push ExtrusionBracket, origin:[0, -FRAME_KLASS.width/2, 0], x:-sign*Z, y:sign*X
                else
                    push ExtrusionBracket, origin:[0, FRAME_KLASS.width/2, 0], x:-sign*Z, y:-sign*X
                end

                if x > 0
                    push ExtrusionBracket, origin:[-FRAME_KLASS.width/2, 0, 0], x:-sign*Z, y:-sign*Y
                else
                    push ExtrusionBracket, origin:[FRAME_KLASS.width/2, 0, 0], x:-sign*Z, y:sign*Y
                end
            end
        end
    end

    # Enclosure
    translate -TopPanel.piston_cutout_center do
        translate 0, 0, -TopPanel.thickness do
            push TopPanel

            # Piston chamber mounting hardware
            TopPanel.bracket_bolt_holes.each do |center|
                s = (center.y <=> TopPanel.piston_cutout_center.y)
                translate *(-s*Point[LBracket.bottom_hole_center.to_a.reverse]) , 0 do
                    push LBracket, origin:[*center, 0], x:s*Y, y:s*X
                    push FlatWasher, origin:[center.x, center.y - s*ChamberSidePanel.length, -1.2.cm], x:X, y:s*Z
                end
                push FlatWasher, origin:[*center, TopPanel.length]
            end

        end
        push BottomPanel, origin:[0, 0, -Z_RAIL_LENGTH - BottomPanel.thickness]

        # Top deck attachment bolts
        TopPanel.side_bolt_holes.each do |center|
            push FlatWasher, origin:[*center, 0]
            push M5x12Bolt, origin:[*center, FlatWasher.length], x:X, y:-Y
        end
        TopPanel.front_bolt_holes.each do |center|
            push FlatWasher, origin:[*center, 0]
            push M5x12Bolt, origin:[*center, FlatWasher.length], x:X, y:-Y
        end

        push BackPanel, origin:[DECK_SIZE.x*2/3, X_RAIL_SPACING + DECK_BORDER_TOP, -Z_RAIL_LENGTH - FRAME_KLASS.width - 0.6.cm], x:-X, y:Z

        # Bottom deck attachment bolts
        translate 0, 0, -Z_RAIL_LENGTH - BottomPanel.length + TopPanel.length do
            BottomPanel.side_bolt_holes.each do |center|
                push FlatWasher, origin:[*center, 0]
                push M5x12Bolt, origin:[*center, FlatWasher.length], x:X, y:-Y
            end
            BottomPanel.front_bolt_holes.each do |center|
                push FlatWasher, origin:[*center, 0]
                push M5x12Bolt, origin:[*center, FlatWasher.length], x:X, y:-Y
            end
        end
    end

    # Piston walls
    translate 0, 0, -ACRYLIC_THICKNESS do
        # Chamber walls
        translate 0, -ChamberSidePanel.size.x/2, -ChamberSidePanel.size.y do
            push ChamberFrontPanel, origin:[-ChamberFrontPanel.size.x/2, ChamberSidePanel.size.x, 0], x:X, y:Z
            push ChamberFrontPanel, origin:[-ChamberFrontPanel.size.x/2, ChamberFrontPanel.length, 0], x:X, y:Z

            push ChamberSidePanel, origin:[-(PLATFORM_SIZE.x + PLATFORM_SPACING/2 + ChamberSidePanel.length), 0, 0], x:Y, y:Z     # Left
            push ChamberCenterPanel, origin:[-ChamberCenterPanel.length/2, 0, 0],  x:Y, y:Z     # Center
            push ChamberSidePanel, origin:[PLATFORM_SIZE.x + PLATFORM_SPACING/2, 0, 0], x:Y, y:Z     # Right
        end
    end
end
