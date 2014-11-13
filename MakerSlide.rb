# https://www.inventables.com/technologies/makerslide

extrusion :MakerSlide do
    attr_reader width: 40.mm
    attr_reader height: 20.mm
    attr_reader rail_gauge: (width + 2*3.8.mm).cm
    attr_reader wheel_spacing: 64.4.mm

    right = width/2
    left = -right
    top = height/2
    bottom = -top

    wall_thickness = 2.mm
    pocket_bottom_width = 6.mm	# width of the flat pocket bottom
    pocket_depth = 6.mm		# Measured from outside face
    pocket_opening = 6.mm	# The width of the pocket opening
    pocket_sidewall = 0.95.mm	# The small interior sidewall in the pocket
    pocket_width = 12.mm	# Widest part of the pocket

    pocket_chamfer_height = pocket_depth - pocket_sidewall - wall_thickness
    pocket_chamfer_width = (pocket_width - pocket_bottom_width)/2
    pocket_lip = (pocket_width - pocket_opening)/2

    polygon do
	start_at [right, top]	# Upper right corner

	# Rail on the +X side
	move_y  2.5
	move_x  0.8
	move    [ 2.2, -2.5]	# Peak edge
	move    [-2.2, -2.5]
	move_x  -0.8

	# Opening on far +X side (facing +X)
	vertical_to 3.mm	# Upper corner of the opening
	move_x  -wall_thickness
	move_y  pocket_lip
	move_x  -pocket_sidewall
	move_to [right-pocket_depth,  pocket_bottom_width/2]
	move_y  -pocket_bottom_width	    # Bottom face
	move_to [right - pocket_sidewall-wall_thickness, -pocket_width/2]
	move_x  pocket_sidewall
	move_y  pocket_lip
	move_x  wall_thickness

	move_to [ width/2, -height/2]	# Lower right corner

	# Opening in the X,-Y quadrant, facing -Y
	move [-7, 0]
	move [0, wall_thickness]
	move [pocket_lip, 0]
	move [0, pocket_sidewall]
	move [-pocket_chamfer_width, pocket_chamfer_height]
	move [-pocket_bottom_width, 0]
	move [-pocket_chamfer_width, -pocket_chamfer_height]
	move [0, -pocket_sidewall]
	move [pocket_lip, 0]
	move [0, -wall_thickness]

	# Opening in the -X,-Y quadrant, facing -Y
	move_to [left+7+pocket_opening, bottom]
	move [0, wall_thickness]
	move [pocket_lip, 0]
	move [0, pocket_sidewall]
	move [-pocket_chamfer_width, pocket_chamfer_height]
	move [-pocket_bottom_width, 0]
	move [-pocket_chamfer_width, -pocket_chamfer_height]
	move [0, -pocket_sidewall]
	move [pocket_lip, 0]
	move [0, -wall_thickness]

	move_to [-width/2, -height/2]	# Lower left corner

	# Opening in the -X,-Y quadrant, facing -X
	vertical_to -pocket_opening/2
	move [wall_thickness, 0]
	move [0, -pocket_lip]
	move [pocket_sidewall, 0]
	move [pocket_chamfer_height, pocket_chamfer_width]
	move [0, pocket_bottom_width]
	move [-pocket_chamfer_height, pocket_chamfer_width]
	move [-pocket_sidewall, 0]
	move [0, -pocket_lip]
	move [-wall_thickness, 0]

	# Rail on -X side
	vertical_to top - 2.5
	move [-0.8, 0]
	move [-2.2, 2.5]
	move [2.2, 2.5]
	move [0.8, 0]

	move_to [-width/2,   height/2]	# Upper left corner

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

    central_top_width = 5.0.mm
    polygon do
	start_at	[central_top_width/2, top - wall_thickness]
	move_y	-1.5
	move_to	[6.mm, pocket_bottom_width/2]
	move_y	-pocket_bottom_width
	move_to	[central_top_width/2, bottom + wall_thickness + 1.5]
	move_y	-1.5

	move_x	-central_top_width
	move_y	1.5
	move_to	[-6.mm, -pocket_bottom_width/2]
	move_y	pocket_bottom_width
	move_to	[-central_top_width/2, top - wall_thickness - 1.5]
	move_y	1.5
    end

    polygon do
	start_at	[10 + pocket_width/2, top - wall_thickness]
	move_y	-pocket_sidewall
	move_to	[10 + pocket_bottom_width/2, top - pocket_depth]
	move_x	-pocket_bottom_width
	move_to	[10 - pocket_width/2, top - wall_thickness - pocket_sidewall]
	move_y	pocket_sidewall
    end

    diameter = 4.2.mm
    circle  [-width/4, 0], diameter/2
    circle  [width/4, 0], diameter/2
end
