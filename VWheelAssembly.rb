require_relative 'DualBearingVWheelKit'
require_relative 'fasteners'

model :VWheelAssembly do
    # Put a washer on top of the panel
    push FlatWasher, origin:[0, 0, ACRYLIC_THICKNESS]
    # Put a nut on top of the washer
    push M5HexNut, origin:[0, 0, ACRYLIC_THICKNESS + FlatWasher.length]
    # Put a wheel kit under the panel
    push DualBearingVWheelKit, origin:[0, 0, -PrecisionShim.length - DualBearingVWheelKit.height]
    # Put a washer between the wheel and the panel
    push PrecisionShim, origin:[0, 0, -PrecisionShim.length]
end
