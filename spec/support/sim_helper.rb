module SimHelper

  def level_configuration name = 'test.yml'
    Sim::Buildable.load_config(File.join(Rails.root, 'config', 'levels', name))
  end

end
