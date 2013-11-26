module UserHelper

  def gravatar_for user, size, klass = "gravatar"
    image_tag user.gravatar_url(size: size), alt: user.username, class: klass, size: "#{size}x#{size}"
  end

end
