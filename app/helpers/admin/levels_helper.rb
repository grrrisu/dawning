module Admin::LevelsHelper

  def level_configuration_files
    config_files = Dir.glob(Rails.root.join('config', 'levels', '*.yml'))
    config_files.map {|config_file| config_file.split('/').last }
    #config_files = Rails.root.join('config', 'levels').children.map {|config_file| config_file.split[1].to_s}
  end

end
