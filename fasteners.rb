require 'fasteners'

module Fasteners
    class Nut
	# @return [Class]	Create a new subclass of Model that repesents the {Nut}
	def to_solid
	    nut = self
	    Engineering::DSL.send :extrusion do
		# Copy all attributes to the new class
		nut.instance_variables.each do |name|
		    attr_reader name.to_s.sub('@','').to_sym => nut.instance_variable_get(name)
		end
		attr_reader indiameter: nut.instance_variable_get(:@indiameter)

		length nut.height.cm

		hexagon indiameter:nut.width.cm
		circle diameter:nut.hole_diameter.cm
	    end
	end
    end

    class SocketHeadCapScrew
	# @return [Class]	Create a new subclass of Model that repesents the screw
	def to_solid
	    Engineering::DSL.send :model do
		# Copy all attributes to the new class
		instance_variables.each do |name|
		    attr_reader name.to_s.sub('@','').to_sym => instance_variable_get(name)
		end

		extrude length:head_length, origin:[0, 0, -head_length] do
		    circle diameter:head_diameter
		    hexagon indiameter:socket_diameter
		end

		extrude length:length do
		    circle diameter:diameter
		end
	    end
	end
    end

    class Washer
	# @return [Class]	Create a new subclass of Model that repesents the screw
	def to_solid
	    washer = self
	    Engineering::DSL.send :extrusion do
		length washer.thickness
		circle diameter:washer.outer_diameter
		circle diameter:washer.inner_diameter
	    end
	end
    end
end

# Auto-generate fastener models as they're needed
def Object.const_missing(name)
    if name =~ /M(\d+)x(\d+)Bolt/
	diameter = $1.to_i.mm
	length = $2.to_i.mm
	raise ArgumentError, "Metric bolt size M0 does not exist" if diameter.zero?

	klass = Fasteners::SocketHeadCapScrew.new(diameter, length:length).to_solid
	parent = (Module == self.class) ? self : Object
	parent.const_set(name, klass)
    elsif name =~ /M(\d+)(Thin)?HexNut/
    	diameter = $1.to_i.mm
    	type = ($2 == 'Thin')
	raise ArgumentError, "Metric nut size M0 does not exist" if diameter.zero?

	klass = Fasteners::Metric::Nut.new(hole_diameter:diameter, type:type).to_solid
	parent = (Module == self.class) ? self : Object
	parent.const_set(name, klass)
    else
	super
    end
end

M8HeavyNut = M8HexNut

# https://www.inventables.com/technologies/flat-washer
FlatWasher = Fasteners::Washer.new(inner_diameter:5.3.mm.cm, outer_diameter:1.cm, thickness:1.mm).to_solid

# https://www.inventables.com/technologies/precision-shim-washer
PrecisionShim = Fasteners::Washer.new(inner_diameter:0.5.cm, outer_diameter:1.cm, thickness:1.mm).to_solid
