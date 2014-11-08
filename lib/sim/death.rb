class Death < RuntimeError

  attr_reader :changed_area

  def initialize changed_area, msg = nil
    super msg
    @changed_area = changed_area
  end

end
