module Admin::LevelsHelper

  def level_configuration_files
    config_files = Dir.glob(Rails.root.join('config', 'levels', '*.yml'))
    config_files.map {|config_file| config_file.split('/').last }
  end

end
