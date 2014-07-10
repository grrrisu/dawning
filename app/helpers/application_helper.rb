module ApplicationHelper

  def navigation_item title, breadcrumb, path, link_options = {}
    content_tag(:li, class: navigation_active?(breadcrumb) ? 'active' : nil) do
      link_to title, path, link_options
    end
  end

end
