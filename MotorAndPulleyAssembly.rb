require_relative 'motors/NEMA17x21'
require_relative 'motors/NEMA17x35'
require_relative 'PulleyMXL18'

model :MotorAndPulleyAssembly do
    attr_reader motor_body_length: NEMA17x35.body_length
    attr_reader motor_shaft_length: NEMA17x35.shaft_length

    pulley_height = PulleyMXL18.belt_width + 2*PulleyMXL18.flange_width + PulleyMXL18.hub_length
    pulley_z = motor_body_length + motor_shaft_length - pulley_height - 0.6.cm

    push NEMA17x35
    push PulleyMXL18, origin:[0, 0, pulley_z]
end

model :MotorAndPulleyAssembly21 do
    attr_reader motor_body_length: NEMA17x21.body_length
    attr_reader motor_shaft_length: NEMA17x21.shaft_length

    pulley_height = PulleyMXL18.belt_width + 2*PulleyMXL18.flange_width + PulleyMXL18.hub_length
    pulley_z = motor_body_length + motor_shaft_length - pulley_height

    push NEMA17x21
    push PulleyMXL18, origin:[0, 0, pulley_z]
end
