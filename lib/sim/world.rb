require_relative 'builder/world'

class World < Sim::Matrix
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

  # returns a position within the bounderies, stopping at the bounderies
  def check_bounderies x, y
    x = width() -1 if x < 0
    y = height() -1 if y < 0
    x = 0 if x >= width
    y = 0 if y >= height
    [x, y]
  end

  # returns a position within the bounderies going around the world
  def around_position x, y
    # Array[] handles negative index until -size
    if (0...width) === x && (0...height) === y
      [x, y]
    else
      if x >= width
        x -= width
      elsif x < 0
        x += width
      end
      if y >= height
        y -= height
      elsif y < 0
        y += height
      end
      around_position x, y
    end
  end

  def get_field x, y
    super(*around_position(x, y))
  end
  alias [] get_field

  def set_field x, y, value
    super(*around_position(x, y), value)
  end
  alias []= set_field

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
