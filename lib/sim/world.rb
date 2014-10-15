require_relative 'builder/world'

class World < Sim::Globe
  include Sim::Buildable

  def initialize width, height = nil
    super(width, height) # map width and height to columns and rows
    set_each_field_with_index {|x, y| Sim::FieldProperties.new(x: x, y: y) }
  end

  def build config
    builder = Builder::World.new(self)
    builder.create(config[:builder]) if config[:builder]
    self
  end

  def filter_value x, y
    properties = get_field(x, y)
    properties.inject({}) do |view_properties, property|
      key, value = property[0], property[1]
      view_properties[key] = value.respond_to?(:view_value) ? value.view_value : value
      view_properties
    end
  end

  def inspect
    output = "\n"
    (height-1).downto(0) do |y|
        output += line_output
        %i(vegetation flora fauna).each do |property|
          output += row_field_output {|x| field_as_string(x, y, property) }
        end
        output += row_field_output {|x| "#{x} #{y}"}
    end
    output += line_output
  end

private

  def row_output char
    output = ''
    0.upto(width-1) {|x| output += yield(x) }
    output += "#{char}\n"
  end

  def line_output
    row_output('-') { '-' * 10 }
  end

  def row_field_output
    row_output('|') {|x| "| #{yield(x).rjust(7)} " }
  end

  def field_as_string x, y, property
    self[x,y].try(:[], property).try(:view_value).to_s
  end

end
