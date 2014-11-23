model :Sprocket_GT2_20_5mm do
    attr_reader bore_diameter: 5.mm
    attr_reader diameter: 16.mm
    attr_reader length: 16.mm
    attr_reader belt_width: 6.mm
    attr_reader gear_diameter: 12.mm

    attr_reader flange_thickness: 1.5.mm
    attr_reader hub_diameter: 16.mm
    attr_reader hub_length: length - 2*flange_thickness - belt_width

    # Hub
    extrude length:hub_length do
	annulus inner_diameter:bore_diameter, diameter:hub_diameter
    end

    translate z:hub_length do
	# Bottom Flange
	extrude length:flange_thickness do
	    annulus inner_diameter:bore_diameter, diameter:diameter
	end

	translate z:flange_thickness do
	    # Geared portion
	    extrude length:belt_width do
		annulus inner_diameter:bore_diameter, diameter:gear_diameter
	    end

	    # Top Flange
	    extrude length:flange_thickness, origin:[0,0, belt_width] do
		annulus inner_diameter:bore_diameter, diameter:diameter
	    end
	end
    end
end

model :Sprocket_GT2_36_5mm do
    attr_reader bore_diameter: 5.mm
    attr_reader diameter: 26.mm
    attr_reader length: 16.mm
    attr_reader belt_width: 7.mm
    attr_reader gear_diameter: 22.5.mm

    attr_reader flange_thickness: 1.5.mm
    attr_reader hub_diameter: 14.mm
    attr_reader hub_length: length - 2*flange_thickness - belt_width

    # Hub
    extrude length:hub_length do
	annulus inner_diameter:bore_diameter, diameter:hub_diameter
    end

    translate z:hub_length do
	# Bottom Flange
	extrude length:flange_thickness do
	    annulus inner_diameter:bore_diameter, diameter:diameter
	end

	translate z:flange_thickness do
	    # Geared portion
	    extrude length:belt_width do
		annulus inner_diameter:bore_diameter, diameter:gear_diameter
	    end

	    # Top Flange
	    extrude length:flange_thickness, origin:[0,0, belt_width] do
		annulus inner_diameter:bore_diameter, diameter:diameter
	    end
	end
    end
end

model :Sprocket_GT2_36_10mm do
    attr_reader bore_diameter: 10.mm
    attr_reader diameter: 26.mm
    attr_reader length: 16.mm
    attr_reader belt_width: 7.mm
    attr_reader gear_diameter: 22.5.mm

    attr_reader flange_thickness: 1.5.mm
    attr_reader hub_diameter: 14.mm
    attr_reader hub_length: length - 2*flange_thickness - belt_width

    # Hub
    extrude length:hub_length do
	annulus inner_diameter:bore_diameter, diameter:hub_diameter
    end

    translate z:hub_length do
	# Bottom Flange
	extrude length:flange_thickness do
	    annulus inner_diameter:bore_diameter, diameter:diameter
	end

	translate z:flange_thickness do
	    # Geared portion
	    extrude length:belt_width do
		annulus inner_diameter:bore_diameter, diameter:gear_diameter
	    end

	    # Top Flange
	    extrude length:flange_thickness, origin:[0,0, belt_width] do
		annulus inner_diameter:bore_diameter, diameter:diameter
	    end
	end
    end
end