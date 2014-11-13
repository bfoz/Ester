# https://www.inventables.com/technologies/smooth-idler-wheel-kit

require_relative '../Bearing_5x16x5'
require_relative '../fasteners'

model :IdlerWheelKit do
    # Flange
    extrude length:1.6.mm.cm do
    	circle center:[0,0], diameter:21.mm.cm
    	circle center:[0,0], diameter:15.mm.cm 	# This diameter isn't called out on the drawing. I guessed.
    end

    extrude length:8.mm.cm, origin:[0, 0, 1.6.mm.cm] do
    	circle center:[0,0], diameter:17.5.mm.cm
    	circle center:[0,0], diameter:16.mm.cm
    end

    # Flange
    extrude length:1.6.mm.cm, origin:[0, 0, 1.6.mm.cm + 8.mm.cm] do
    	circle center:[0,0], diameter:21.mm.cm
    	circle center:[0,0], diameter:16.mm.cm
    end

    push Bearing_5x16x5, origin:[0,0, 1.6.mm.cm]
    push PrecisionShim, origin:[0,0, 1.6.mm.cm + 5.mm.cm]
    push Bearing_5x16x5, origin:[0,0, 1.6.mm.cm + 5.mm.cm + 1.mm.cm]
end
