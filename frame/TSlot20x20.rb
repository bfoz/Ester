# Aluminum T-Slot Extrusion, 20mm x 20mm

extrusion :TSlot20x20 do
    attr_reader width: 20.mm
    attr_reader height: 20.mm

    right = width/2
    left = -right
    top = height/2
    bottom = -top

    wall_thickness = 1.8.mm
    pocket_bottom_width = 6.mm	# width of the flat pocket bottom
    pocket_depth = 6.mm		# Measured from outside face
    slot_width = 5.mm		# The width of the pocket opening
    pocket_sidewall = 0.95.mm	# The small interior sidewall in the pocket
    pocket_width = 11.5.mm	# Widest part of the pocket

    pocket_chamfer_height = pocket_depth - pocket_sidewall - wall_thickness
    pocket_chamfer_width = (pocket_width - pocket_bottom_width)/2
    pocket_lip = (pocket_width - slot_width)/2

    polygon do
	start_at [right, top]	# Upper right corner

	# Opening on far +X side (facing +X)
	vertical_to slot_width/2	# Upper corner of the opening
	move_x  -wall_thickness
	move_y  pocket_lip
	move_x  -pocket_sidewall
	move_to [right-pocket_depth,  pocket_bottom_width/2]
	move_y  -pocket_bottom_width	    # Bottom face
	move_to [right - pocket_sidewall-wall_thickness, -pocket_width/2]
	move_x  pocket_sidewall
	move_y  pocket_lip
	move_x  wall_thickness

	move_to [right, bottom]		# Lower right corner

	# Opening in the X,-Y quadrant, facing -Y
	horizontal_to	slot_width/2
	up 	wall_thickness
	right 	pocket_lip
	up 	pocket_sidewall
	move [-pocket_chamfer_width, pocket_chamfer_height]
	move [-pocket_bottom_width, 0]
	move [-pocket_chamfer_width, -pocket_chamfer_height]
	move [0, -pocket_sidewall]
	move [pocket_lip, 0]
	move [0, -wall_thickness]

	move_to [left, bottom]	# Lower left corner

	# Opening in the -X,-Y quadrant, facing -X
	vertical_to -slot_width/2
	move [wall_thickness, 0]
	move [0, -pocket_lip]
	move [pocket_sidewall, 0]
	move [pocket_chamfer_height, pocket_chamfer_width]
	move [0, pocket_bottom_width]
	move [-pocket_chamfer_height, pocket_chamfer_width]
	move [-pocket_sidewall, 0]
	move [0, -pocket_lip]
	move [-wall_thickness, 0]

	move_to [left, top]	# Upper left corner

	# Opening in the -X,-Y quadrant, facing +Y
	move [7, 0]
	move [0, -wall_thickness]
	move [-pocket_lip, 0]
	move [0, -pocket_sidewall]
	move [pocket_chamfer_width, -pocket_chamfer_height]
	move [pocket_bottom_width, 0]
	move [pocket_chamfer_width, pocket_chamfer_height]
	move [0, pocket_sidewall]
	move [-pocket_lip, 0]
	move [0, wall_thickness]
    end

    circle diameter:4.3.mm
end