require 'optical'

require_relative 'thorlabs/sm05rr'
require_relative 'thorlabs/s05ldm9'
require_relative 'thorlabs/sm05l05'
require_relative 'thorlabs/sm05l10'

model :LaserDiode do
    attr_reader base_thickness: 1.2.mm
    attr_reader length: base_thickness + 3.5.mm

    # The LD emitter surface appears to be 2mm from the end of the package
    attr_reader emitter_height: length - 2.mm

    extrude length:base_thickness do
        circle diameter:9.mm
    end
    extrude length:3.5.mm, origin:[0, 0, 1.2.mm] do
        circle diameter:6.4.mm
    end
end

model :InputLens do
    attr_reader lens: Optical::Lens.new(diameter:12.7.mm, focal_length:11.6.mm, center_thickness:5.1.mm, edge_thickness:1.8.mm)

    # The cylindrical portion of a PlanoConvex lens
    extrude length:lens.edge_thickness do
        circle diameter:lens.diameter
    end

    # The spherical portion of a PlanoConvex lens
    extrude length:lens.thickness - lens.edge_thickness, origin:[0,0,lens.edge_thickness] do
        circle diameter:lens.diameter
    end
end

model :OutputLens do
    attr_reader lens: Optical::Lens.new(diameter:12.7.mm, focal_length:27.9.mm, center_thickness:3.2.mm, edge_thickness:1.8.mm)

    # The cylindrical portion of a PlanoConvex lens
    extrude length:lens.edge_thickness do
        circle diameter:lens.diameter
    end

    # The spherical portion of a PlanoConvex lens
    extrude length:lens.thickness - lens.edge_thickness, origin:[0,0,lens.edge_thickness] do
        circle diameter:lens.diameter
    end
end

# 2-inch lens tube
model :OpticalAssembly do
    input_lens = Optical::PlanoConvexLens.new(diameter:12.7.mm, focal_length:11.6.mm, center_thickness:5.1.mm, edge_thickness:1.8.mm, radius_of_curvature:7.mm)
    output_lens = Optical::PlanoConvexLens.new(diameter:12.7.mm, focal_length:48.3.mm, center_thickness:2.6.mm, edge_thickness:1.8.mm, radius_of_curvature:25.8.mm)

    attr_reader working_distance: output_lens.focal_length

    push OutputLens

    push SM05RR, origin:[0, 0, output_lens.thickness(diameter:SM05RR.inner_diameter)]

    # Lens tubes
    push SM05L05, origin:[0, 0, -SM05L05.lens_bottom_z]
    translate 0, 0, SM05L05.length - SM05L05.lens_bottom_z - SM05L10.outer_thread_length do
        push SM05L10

        translate 0, 0, SM05L10.lens_bottom_z do
            translate 0, 0, input_lens.thickness(diameter:SM05RR.inner_diameter) do
                push InputLens, x:X, y:-Y
                push SM05RR

                translate 0, 0, input_lens.focal_length + LaserDiode.emitter_height do
                    push LaserDiode, x:X, y:-Y
                    translate 0, 0, -S05LDM9.laser_surface_offset - LaserDiode.base_thickness do
                        push S05LDM9
                        push SM05RR, origin:[0,0,-SM05RR.length]
                    end
                end
            end
        end
    end
end
