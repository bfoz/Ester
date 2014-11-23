require_relative 'motors/NEMA17x21'
require_relative 'motors/NEMA17x35'
require_relative 'sprockets'

model :XMotorAndSprocketAssembly do
    attr_reader motor_body_length: NEMA17x21.body_length
    attr_reader motor_body_width: NEMA17x21.body_width
    attr_reader motor_shaft_length: NEMA17x21.shaft_length

    pulley_z = motor_body_length + motor_shaft_length - Sprocket_GT2_20_5mm.length + 6.mm

    push NEMA17x21
    push Sprocket_GT2_20_5mm, origin:[0, 0, pulley_z]
end

model :YMotorAndSprocketAssembly do
    attr_reader motor_body_length: NEMA17x21.body_length
    attr_reader motor_body_width: NEMA17x21.body_width
    attr_reader motor_shaft_length: NEMA17x21.shaft_length

    pulley_z = motor_body_length + motor_shaft_length - Sprocket_GT2_20_5mm.length + 4.mm

    push NEMA17x21
    push Sprocket_GT2_20_5mm, origin:[0, 0, pulley_z]
end
