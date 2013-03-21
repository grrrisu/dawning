module Navigation
  
  def self.included(base)
    base.extend ClassMethods
    base.instance_eval do
      helper_method :navigation_active?
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
    
    def navigation *breadcrumbs
      self.class.navigation *breadcrumbs
    end
    
    def navigation_active? key
      self.class.breadcrumbs.include?(key)
    end
    
  end
  
end