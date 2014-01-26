module MapsHelper

  def images_with_asset_path images
    @images.inject({}) {|h, image| h[image[0]] = asset_path(image[1]); h }
  end

end
