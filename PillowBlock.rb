# http://www.adafruit.com/products/1179
# SC8UU

extrusion :PillowBlock do
    attr_reader height: 22.mm.cm
    attr_reader width: 34.mm.cm
    attr_reader shaft_diameter: 8.mm.cm

    length  30.mm.cm

    rectangle center:[0,0], size:[width, height]	

    circle diameter:shaft_diameter
end