model :NEMA17 do
    attr_reader body_length: 48.mm.cm
    attr_reader body_width: 42.3.mm.cm
    attr_reader shaft_length: 24.mm.cm
    attr_reader bolt_hole_diameter: 3.mm

    width = 42.3.mm
    face_width = 31.0.mm
    hole_spacing = 31.0.mm
    attr_reader shaft_diameter: 5.0.mm
    attr_reader bolt_holes: [-hole_spacing/2, hole_spacing/2].product([-hole_spacing/2, hole_spacing/2])

    origin = [0,0, body_length]

    bhd = bolt_hole_diameter
    # The body of the motor
    extrude length: body_length do
	polygon do
	    start_at	[-face_width/2, -width/2]
	    move_to	[-width/2, -face_width/2]
	    move_y	face_width
	    move_to	[-face_width/2, width/2]
	    move_x	face_width
	    move_to	[width/2, face_width/2]
	    move_y	-face_width
	    move_to	[face_width/2, -width/2]
	end

	repeat step:hole_spacing, count:[2,2] do
	    circle diameter:bolt_hole_diameter
	end
    end
    
    # A short stub of wires sticking out of the side
    extrude length: 1.mm, origin: [width/2, -2.5.mm, 0] do
	rectangle origin:Point[0,0], size:Size[10.mm, 5.mm]
    end

    # The front side of the motor shaft
    extrude length: shaft_length, origin: [0, 0, body_length] do
	circle center:[0,0], :diameter => shaft_diameter
    end

    # A circular feature around the base of the shaft
    extrude length: 2.mm, origin: [0,0, body_length] do
	circle center:[0,0], radius:22.0.mm/2
    end
end
