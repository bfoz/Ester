require_relative 'thorlabs/sm05rcm'

require_relative 'fasteners'
require_relative 'LaserBracket'
require_relative 'OpticalAssembly'
require_relative 'VWheelAssembly'

wheel_spacing = 3.5.cm
WHEEL_BEARING_HOLE_SIZES = [5.mm.cm, 5.mm.cm, 7.1.mm.cm]
# This assumes that the rail is running along the X-axis
# The eccentric spacer hole is the on the +Y side of the rail
def wheel_bearing_hole_pattern(x_spacing=5.2.cm)
    half_v_width = 2.cm + 3.mm.cm
    groove_radius = DualBearingVWheelKit.groove_diameter/2
    [   [-x_spacing/2, -(half_v_width + groove_radius)],
        [ x_spacing/2, -(half_v_width + groove_radius)],
        [0,   half_v_width + groove_radius]]
end

extrusion :YCarriagePanel do
    attr_reader rail_offset: -4.4.cm
    attr_reader belt_anchor_holes: repeat(center:[0, rail_offset-(0.4375.inch.cm/2)], step:[1.5.cm,0], count:[2,1])
    attr_reader thickness: PANEL_THICKNESS

    length thickness
    rectangle origin:[-3.5.cm, -8.5.cm], size:[7.cm, 10.cm]

    # Optical pass-thru
    circle center:[0, 0], diameter:SM05L05.diameter

    # Retainer plate mounting bolts
    repeat spacing:[28.mm, 0], count:[2,1] do
        circle diameter:5.mm
    end

    translate [0, rail_offset] do
        # Wheel bearing holes
        wheel_bearing_hole_pattern.zip(WHEEL_BEARING_HOLE_SIZES).each do |center, diameter|
            circle center:[center.first, -center.last], diameter:diameter
        end

        # Belt anchor mounting holes
        translate 0, -0.4375.inch.cm/2.cm do
            circle center:[-0.75.cm, 0], diameter:5.mm.cm
            circle center:[0.75.cm, 0], diameter:5.mm.cm
        end
    end
end

extrusion :LensTubeRetainerPlate do
    length ACRYLIC_THICKNESS
    rectangle center:[0,0], size:[37.mm, 30.mm]

    # Lens tube pass-thru
    circle center:[0, 0], diameter:SM05L05.diameter

    # Mounting bolts
    repeat spacing:[28.mm, 0], count:[2,1] do
        circle diameter:5.mm
    end
end

model :YCarriageAssembly do
    attr_reader panel_klass: YCarriagePanel
    attr_reader rail_offset: panel_klass.rail_offset

    push panel_klass
    panel_klass.belt_anchor_holes.each do |center|
        push M5x20Bolt, origin:[center.x, center.y, 0]
        push M5HexNut, origin:[center.x, center.y, panel_klass.thickness]
    end

    translate 0, rail_offset, 0 do
        wheel_bearing_hole_pattern.each do |x, y|
            push VWheelAssembly, origin:[x, -y, 0]
        end
    end

    push OpticalAssembly, origin:[0,0, -(58.3.mm - OpticalAssembly.working_distance)]
    push SM05RCM, origin:[0, 0, panel_klass.length]
    push LensTubeRetainerPlate, origin:[0, 0, panel_klass.length + SM05RCM.length]
    translate 0, 0, panel_klass.length + SM05RCM.length + LensTubeRetainerPlate.length do
        push M5x25Bolt, origin:[-14.mm, 0, 0], x:X, y:-Y
        push M5x25Bolt, origin:[14.mm, 0, 0], x:X, y:-Y
    end
    push M5HexNut, origin:[-14.mm, 0, -M5HexNut.length]
    push M5HexNut, origin:[14.mm, 0, -M5HexNut.length]
end
