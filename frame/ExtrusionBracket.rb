# https://www.inventables.com/technologies/extrusion-bracket--2
model :ExtrusionBracket do
    face_size = Size[35.mm, 14.mm]
    half = face_size.y/2
    thickness = 5.mm

    # Bottom half
    extrude length:thickness do
	rectangle origin:[0, -half], size:face_size
	circle center:[25.mm, 0], diameter:5.5.mm
    end

    # Vertical half
    extrude length:thickness, origin:[thickness, 0, thickness], x:Z, y:Y do
	rectangle origin:[0, -half], size:[face_size.x-thickness, face_size.y]
	circle center:[25.mm - thickness, 0], diameter:5.5.mm
    end
end
