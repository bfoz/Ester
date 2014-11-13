# http://www.thorlabs.us/thorproduct.cfm?partnumber=S05LDM9
model :S05LDM9 do
    attr_reader outer_diameter: 0.535.inch.mm
    attr_reader length: 7.6.mm
    attr_reader inner_length: 5.8.mm
    attr_reader laser_surface_offset: 0.9.mm

    # First step
	extrude length:laser_surface_offset do
        circle diameter:outer_diameter
        circle diameter:7.6.mm
    end

    # Second step
    extrude origin:[0, 0, laser_surface_offset], length:0.9.mm do
        circle diameter:outer_diameter
        circle diameter:9.mm
    end

    # Body
    extrude origin:[0, 0, laser_surface_offset + 0.9.mm], length:inner_length do
        circle diameter:outer_diameter
        circle diameter:(13/32).inch
    end
end