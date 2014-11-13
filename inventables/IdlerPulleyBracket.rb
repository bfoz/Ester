# https://www.inventables.com/technologies/idler-pulley-bracket

model :IdlerPulleyBracket do
    extrude length:1.5.mm.cm do
        rectangle center:[0,0], size:[39.5.mm.cm, 35.mm.cm]

        # Mounting holes
        circle center:[-10.mm.cm, 12.mm.cm], diameter:5.1.mm.cm
        circle center:[15.mm.cm, 0], diameter:5.1.mm.cm
        circle center:[-10.mm.cm, -12.mm.cm], diameter:5.1.mm.cm
    end

    # M5 x 25mm bolt
    extrude length:2.5.cm do
        circle center:[0,0], diameter:5.mm.cm
    end
end
