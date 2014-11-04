# flora represents some key flora types
# example could be banana, fruit, special herbs
class Flora < Vegetation

  def field= field
    @field      = field
    field.flora = self
  end

end
