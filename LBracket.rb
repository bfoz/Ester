model :LBracket do
    attr_reader bottom_hole_center: [12.mm, 0]
    attr_reader thickness: 2.mm

    face_size = Size[19.mm, 13.mm]
    half = face_size.y/2

    # Bottom half
    extrude length:thickness do
	rectangle origin:[0, -half], size:face_size
	circle center:bottom_hole_center, diameter:4.mm
    end

    # Vertical half
    extrude length:thickness, origin:[thickness, 0, thickness], x:Z, y:Y do
    	rectangle origin:[0, -half], size:[face_size.x-thickness, face_size.y]
	circle center:[10.mm, 0], diameter:4.mm
    end
end
