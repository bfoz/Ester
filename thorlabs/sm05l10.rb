=begin
A one-inch long SM05-threaded lens tube
http://www.thorlabs.us/thorproduct.cfm?partnumber=SM05L10
=end
model :SM05L10 do
    attr_reader diameter: 17.8.mm
    attr_reader length: 28.2.mm
    attr_reader inner_thread_length: 25.4.mm
    attr_reader outer_thread_length: 2.mm
    attr_reader lens_bottom_z: length - inner_thread_length

    # Threaded attachment
	extrude length:length - inner_thread_length do
        circle diameter:0.535.inch
        circle diameter:10.9.mm
    end

    # Smooth body
    extrude origin:[0,0,outer_thread_length], length:length - outer_thread_length do
        circle diameter:diameter
        circle diameter:0.535.inch
    end
end