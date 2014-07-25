RSpec.configure do |config|

  config.after(:each) do |example|
    if example.exception
      puts "\e[0;31m#{example.exception}"
      puts example.exception.backtrace.reject {|line| line =~ /\/gems\//}.join("\n")
      puts "\e[0m"
      if example.metadata[:wait]
        puts "Scenario failed. We wait because of wait. Press enter when you are done"
        $stdin.gets
      elsif example.metadata[:pry]
        require 'pry'
        binding.send(:pry)
      end
    end
  end

end
