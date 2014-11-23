model :F608ZZ do
    attr_reader flange_diameter: 25.mm
    attr_reader flange_thickness: 1.5.mm
    attr_reader inner_diameter: 8.mm
    attr_reader outer_diameter: 22.mm

    attr_reader height:7.mm

    # The flange
    extrude length:flange_thickness do
    	annulus inner_diameter:inner_diameter, diameter:flange_diameter
    end

    extrude origin:[0,0,flange_thickness], length:height - flange_thickness do
    	annulus inner_diameter:inner_diameter, diameter:outer_diameter
    end
end