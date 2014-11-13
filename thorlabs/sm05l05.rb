=begin
A half-inch long SM05-threaded lens tube
http://www.thorlabs.us/thorproduct.cfm?partnumber=SM05L05
=end
model :SM05L05 do
    attr_reader diameter: 17.8.mm
    attr_reader length: 15.5.mm
    attr_reader inner_thread_length: 12.7.mm
    attr_reader outer_thread_length: 2.mm
    attr_reader lens_bottom_z: length - inner_thread_length

    # Threaded attachment
	extrude length:length - inner_thread_length do
        annulus inner_diameter:10.9.mm, diameter:0.535.inch
    end

    # Smooth body
    extrude origin:[0,0,outer_thread_length], length:length - outer_thread_length do
        annulus inner_diameter:0.535.inch, diameter:diameter
    end
end