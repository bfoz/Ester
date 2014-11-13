=begin
SM05RC/M - Ø1/2" (SM05) Series Slim Lens Tube Slip Ring, M4 Tapped Hole
http://www.thorlabs.us/thorproduct.cfm?partnumber=SM05RC/M
=end
extrusion :SM05RCM do
    attr_reader inner_diameter: 18.mm
    attr_reader outer_diameter: 30.mm
    attr_reader inner_radius: inner_diameter/2
    attr_reader thickness: outer_diameter - inner_diameter

    length 10.mm

    circle diameter:outer_diameter
    circle diameter:inner_diameter
end
