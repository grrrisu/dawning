class MapsController < ApplicationController
  navigation :map

  before_filter :get_running_level
  before_filter :prepare_map_images, only: :show

  # setup html for map
  def show
    authorize! :show, @level
  end

private

  def get_running_level
    if @level =  LevelProxy.find(params[:level_id])
      if current_user.admin?
        raise Exception, "level #{params[:level_id]} is not yet build" if @level.state == :launched
      else
        raise Exception, "level #{params[:level_id]} is not running" unless @level.state == :running
      end
    else
      if current_user.admin?
        redirect_to admin_launch_panel_path
      else
        redirect_to levels_path
      end
    end
  end

  def prepare_map_images
    @images = {
      'fog' => 'map/fog3.png',
      '0_desert' => 'map/0_desert@2x.png',
      '1_grass' => 'map/1_grass@2x.png',
      '2_grass' => 'map/2_grass@2x.png',
      '3_grass' => 'map/3_grass@2x.png',
      '5_grass' => 'map/5_grass@2x.png',
      '8_forest' => 'map/8_forest@2x.png',
      '13_forest' => 'map/13_forest@2x.png',
      'banana_1' => 'map/banana-1.png',
      'banana_2' => 'map/banana-2.png',
      'banana_3' => 'map/banana-3.png',
      'rabbit' => 'map/rabbit.png',
      'gazelle' => 'map/gazelle.png',
      'mammoth' => 'map/meat.png',
      'leopard' => 'map/leopard.png',
      'headquarter' => 'map/Raratonga_Mask.gif',
      'pawn' => 'map/caveman.png'
    }
  end

end
