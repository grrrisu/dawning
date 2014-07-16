module MapsHelper

  def images_with_asset_path images
    @images.inject({}) {|h, image| h[image[0]] = asset_path(image[1]); h }
  end

  def websocket_url
    if Rails.env.production? || Rails.env.staging?
      "#{request.host}/websocket"
    else
      "#{request.host}:#{request.port}/websocket"
    end
  end

end
