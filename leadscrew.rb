# Threaded rod
extrusion :Leadscrew do
    circle diameter:8.mm
end

extrusion :LeadscrewNutRetainerPanel do
    hole_spacing = 2.cm
    holes_x = [-hole_spacing/2, hole_spacing/2]
    holes_y = holes_x

    length PANEL_THICKNESS

    rectangle center:[0,0], size:[3.cm, 3.cm]
    circle center:[0,0], diameter:7.mm
    repeat step:2.cm, count:[2,2] do
        circle diameter:5.mm
    end
    # holes_x.product(holes_y) {|x, y| circle center:[x,y], diameter:0.5.cm }
end

extrusion :LeadscrewNutLockPanel do
    hole_spacing = 2.cm
    holes_x = [-hole_spacing/2, hole_spacing/2]
    holes_y = holes_x
    attr_reader holes: holes_x.product(holes_y)

    length PANEL_THICKNESS
    rectangle center:[0,0], size:[3.cm, 3.cm]
    hexagon inradius:13.5.mm/2
    holes_x.product(holes_y) {|x, y| circle center:[x,y], diameter:0.5.cm }
end