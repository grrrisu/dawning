# reopen the SimpleForm to rewrite the hint method 
module SimpleForm 
  module Components 
    module Hints 
      def hint
        @hint ||= begin
          hint = options[:hint]
          hint_content = hint.is_a?(String) ? hint : translate(:hints)
          hint_content.html_safe if hint_content && !options[:hint_escape]
        end
      end
    end 
  end 
end