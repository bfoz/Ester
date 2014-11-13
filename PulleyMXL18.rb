model :PulleyMXL18 do
    attr_reader belt_width: 0.25.inch.cm
    attr_reader flange_width: 0.0625.inch.cm
    attr_reader hub_length: 0.25.inch.cm

    length = 0.687.inch.cm
    diameter = (0.3127*2.54).cm
    flange_diameter = 0.63.inch.cm
    bore_diameter = ((3/16)*2.54).cm
    hub_diameter = (0.4375*2.54).cm   # 7/16
    outer_diameter = (0.438*2.54).cm
    pulley_diameter = (0.458*2.54).cm

    # Hub
    extrude length:hub_length do
        circle [0,0,0], hub_diameter/2
    end

    # Flange
    extrude length:flange_width, :origin => [0,0,hub_length] do
        circle [0,0], flange_diameter/2
    end
    
    extrude length:belt_width, :origin => [0,0,hub_length+flange_width] do
        circle [0,0], pulley_diameter/2
    end

    # Flange
    extrude length:flange_width, :origin => [0,0,hub_length+flange_width+belt_width] do
        circle [0,0], flange_diameter/2
    end
end
