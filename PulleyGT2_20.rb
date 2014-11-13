model :PulleyGT2_20_5mm do
    attr_reader bore_diameter: 5.mm
    attr_reader diameter: 16.mm
    attr_reader length: 16.mm
    attr_reader belt_width: 6.mm
    attr_reader gear_diameter: 12.mm

    attr_reader flange_thickness: 1.5.mm
    attr_reader hub_length: length - 2*flange_thickness - belt_width

    # Hub
    extrude length:hub_length do
        circle diameter:diameter
        circle diameter:bore_diameter
    end

    translate 0, 0, hub_length do
        # Bottom Flange
        extrude length:flange_thickness do
            circle diameter:diameter
            circle diameter:bore_diameter
        end
        
        translate 0, 0, flange_thickness do
            # Geared portion
            extrude length:belt_width do
                circle diameter:gear_diameter
                circle diameter:bore_diameter
            end

            # Top Flange
            extrude length:flange_thickness, origin:[0,0, belt_width] do
                circle diameter:diameter
                circle diameter:bore_diameter
            end
        end
    end
end

model :PulleyGT2_20_8mm do
    attr_reader bore_diameter: 8.mm
    attr_reader diameter: 18.mm
    attr_reader length: 16.mm
    attr_reader belt_width: 6.mm
    attr_reader gear_diameter: 12.mm

    attr_reader flange_thickness: 1.5.mm
    attr_reader hub_length: length - 2*flange_thickness - belt_width

    # Hub
    extrude length:hub_length do
        circle diameter:diameter
        circle diameter:bore_diameter
    end

    translate 0, 0, hub_length do
        # Bottom Flange
        extrude length:flange_thickness do
            circle diameter:diameter
            circle diameter:bore_diameter
        end
        
        translate 0, 0, flange_thickness do
            # Geared portion
            extrude length:belt_width do
                circle diameter:gear_diameter
                circle diameter:bore_diameter
            end

            # Top Flange
            extrude length:flange_thickness, origin:[0,0, belt_width] do
                circle diameter:diameter
                circle diameter:bore_diameter
            end
        end
    end
end

model :PulleyGT2_36_8mm do
    attr_reader bore_diameter: 8.mm
    attr_reader diameter: 26.mm
    attr_reader length: 16.mm
    attr_reader belt_width: 7.mm
    attr_reader gear_diameter: 22.5.mm

    attr_reader flange_thickness: 1.5.mm
    attr_reader hub_diameter: 14.mm
    attr_reader hub_length: length - 2*flange_thickness - belt_width

    # Hub
    extrude length:hub_length do
        circle diameter:hub_diameter
        circle diameter:bore_diameter
    end

    translate 0, 0, hub_length do
        # Bottom Flange
        extrude length:flange_thickness do
            circle diameter:diameter
            circle diameter:bore_diameter
        end

        translate 0, 0, flange_thickness do
            # Geared portion
            extrude length:belt_width do
                circle diameter:gear_diameter
                circle diameter:bore_diameter
            end

            # Top Flange
            extrude length:flange_thickness, origin:[0,0, belt_width] do
                circle diameter:diameter
                circle diameter:bore_diameter
            end
        end
    end
end
