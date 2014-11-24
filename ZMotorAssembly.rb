model :ZMotorAssembly do
    sprocket_z = NEMA17.body_length + NEMA17.shaft_length - 5.mm
    attr_reader belt_bottom: sprocket_z - Sprocket_GT2_36_5mm.belt_top
    attr_reader belt_top: sprocket_z - Sprocket_GT2_36_5mm.belt_bottom
    attr_reader sprocket_top: 61.mm     # Measured in SketchUp

    push NEMA17
    push Sprocket_GT2_36_5mm, origin:[0, 0, sprocket_z], x:X, y:-Y
end
