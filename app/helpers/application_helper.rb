module ApplicationHelper

  def navigation_item title, path, link_options = {}
    breadcrumb = title.gsub(' ','').underscore.to_sym
    content_tag(:li, :class => navigation_active?(breadcrumb) ? 'active' : nil) do
      link_to title, path, link_options
    end
  end

end
