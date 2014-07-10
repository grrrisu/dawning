module Navigation

  def self.included(base)
    base.extend ClassMethods
    base.instance_eval do
      helper_method :navigation_active?, :subnavigation_active?, :page_title
    end
    base.send(:include, InstanceMethods)
  end

  module ClassMethods

    def navigation *breadcrumbs
      @breadcrumbs = breadcrumbs
    end

    def breadcrumbs
      @breadcrumbs || []
    end

  end

  module InstanceMethods

    def page_title
      self.class.breadcrumbs.map(&:to_s).map(&:titleize).join(' ')
    end

    def navigation *breadcrumbs
      self.class.navigation *breadcrumbs
    end

    def subnavigation_active? key
      self.class.breadcrumbs.include?(key)
    end

    def navigation_active? keys
      self.class.breadcrumbs.sort == keys.sort
    end

  end

end
