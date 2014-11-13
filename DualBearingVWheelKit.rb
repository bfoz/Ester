require_relative 'Bearing_5x16x5'
require_relative 'fasteners'

extrusion :DelrinVWheel do
    attr_reader diameter:23.5.mm.cm
    attr_reader groove_diameter:18.75.mm.cm

    length 0.75.cm
    circle center:[0,0], diameter:2.35.cm
    circle diameter:1.595.cm
end

# https://www.inventables.com/technologies/dual-bearing-v-wheel-kit
model :DualBearingVWheelKit do
    attr_reader diameter:23.5.mm.cm
    attr_reader height:2*Bearing_5x16x5.length + PrecisionShim.length
    attr_reader groove_diameter:18.7.mm.cm

    push M5x25Bolt
    push DelrinVWheel, origin:[0, 0, Bearing_5x16x5.length + PrecisionShim.length/2 - DelrinVWheel.length/2]
    push Bearing_5x16x5
    push PrecisionShim, origin:[0, 0, Bearing_5x16x5.length]
    push Bearing_5x16x5, origin:[0, 0, Bearing_5x16x5.length + PrecisionShim.length]
end