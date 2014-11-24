require_relative 'motors/NEMA17'
require_relative 'panels/DeckPanel'

extrusion :EnclosureFrontPanel do
    # !@attribute [r] thickness
    #   @return [Number]    the panel thickness (same as the extrusion length)
    attr_reader thickness: ENCLOSURE_THICKNESS

    attr_reader size: Size[ENCLOSURE_BOX.x, ENCLOSURE_BOX.z]

    length thickness
    rectangle size: size

    # Orientation marker
    translate FRAME_KLASS.width/2, FRAME_KLASS.width/2 do
        circle diameter:5.mm
        rectangle origin:[1.cm, 0], size:[1.cm, 1.mm]
        rectangle origin:[0, 1.cm], size:[1.mm, 1.cm]
    end
end

extrusion :EnclosureSidePanel do
    # !@attribute [r] thickness
    #   @return [Number]    the panel thickness (same as the extrusion length)
    attr_reader thickness: ENCLOSURE_THICKNESS

    attr_reader size: Size[ENCLOSURE_BOX.y, ENCLOSURE_BOX.z]

    length thickness
    rectangle size: size

    # Orientation marker
    translate FRAME_KLASS.width/2, FRAME_KLASS.width/2 do
        circle diameter:5.mm
        rectangle origin:[1.cm, 0], size:[1.cm, 1.mm]
        rectangle origin:[0, 1.cm], size:[1.mm, 1.cm]
    end
end

extrusion :TopPanel do
    # !@attribute [r] thickness
    #   @return [Number]    the panel thickness (same as the extrusion length)
    attr_reader thickness: ENCLOSURE_THICKNESS

    size = DECK_SIZE

    length thickness
    rectangle size: DECK_SIZE

    # Orientation marker
    translate FRAME_KLASS.width/2, FRAME_KLASS.width/2 do
        circle diameter:5.mm
        rectangle origin:[1.cm, 0], size:[1.cm, 1.mm]
        rectangle origin:[0, 1.cm], size:[1.mm, 1.cm]
    end
end

# extrusion :BackPanel do
#     length PANEL_THICKNESS
#     size = Size[12.cm, Z_RAIL_LENGTH + FRAME_KLASS.width]

#     rectangle size:size

#     # Bolt holes for mounting to the frame
#     repeat center:size/2, step:size.inset(2.cm, FRAME_KLASS.width/2), count:2 do
#         circle diameter:5.mm
#     end

#     # Motor driver board mounting holes
#     repeat center:[size.x/2, 15.cm], step:10.cm, count:[2,2] do
#         circle diameter:3.mm.cm
#     end

#     # Laser driver board mounting holes
#     repeat center:[size.x/2, 5.5.cm], step:[67.75.mm, 72.75.mm], count:2 do
#         circle diameter:2.5.mm
#     end
# end
