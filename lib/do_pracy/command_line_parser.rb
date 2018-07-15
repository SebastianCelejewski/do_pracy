module DoPracy
	class CommandLineParser
		def parse

			options = {zoom:12, steps:5000, show_tails:false, show_names:false}

			OptionParser.new do |opts|
				opts.banner = "Usage: ruby bin/do_pracy.rb [options]"
				opts.on("-n", "--show-names", "Shows names next to animated vehicle") { |v| options[:show_names] = v }
		  		opts.on("-t", "--show-tail", "Show tail after animated vehicle") { |v| options[:show_tails] = v }
		  		opts.on("-z Z", "--zoom Z", Integer, "Sets zoom (default: 12)") { |v| options[:zoom] = v}
		  		opts.on("-s S", "--steps S", Integer, "Sets number of steps (default: 5000)") { |v| options[:steps] = v}

			end.parse!

			return options
		end
	end
end