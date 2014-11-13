# http://www.thorlabs.us/thorproduct.cfm?partnumber=SM05RR
extrusion :SM05RR do
    attr_reader inner_diameter: 11.mm
    attr_reader outer_diameter: 0.535.inch.mm
    attr_reader inner_radius: inner_diameter/2
    attr_reader thickness: outer_diameter - inner_diameter

    length 1.7.mm

    circle diameter:outer_diameter
    circle diameter:inner_diameter
end
