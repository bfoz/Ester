# Laser heatsink - Aluminum square stock

extrusion :LaserBracket do
    attr_reader bolt_hole_diameter: 3.1.mm
    attr_reader holes: repeat(step:1.7.cm, count:[2,2])
    attr_reader pass_thru_diameter:15.1.mm

    length  30.mm.cm

    square 1.inch.cm

    # Bolt holes
    spacing = 1.7.cm
    [-spacing/2, spacing/2].product([-spacing/2, spacing/2]).each do |x, y|
        circle center:[x, y], diameter:bolt_hole_diameter	# The diameter was adjusted by hand to be self-tapping
    end

    # Laser hole
    circle diameter:pass_thru_diameter	# Friction fit for the laser housing. It could be a touch larger, but it works well enough for now.
end
