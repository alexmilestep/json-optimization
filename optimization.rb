require_relative 'events-optimization'
require 'optparse'

ONLY_ONE_OPTIMIZATION_OPTION = 'You can provide only one option from [-c, -d] to reduce events'
REDUCE_SIZE_AVAILABLE = 'Available -d range - from 10 to 90'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: EventsOptimization [options]"
  opts.on('-f [ARG]', "Specify json file") do |v|
    options[:f] = v
  end
  opts.on('-d [ARG]', "Desired size reduction \% e.g. -d 40, default - 30") do |v|
    if options[:c]
      puts ONLY_ONE_OPTIMIZATION_OPTION
      exit
    end
    if v.to_i < 10 || v.to_i > 90
      puts REDUCE_SIZE_AVAILABLE
      exit
    end
    options[:d] = v.to_f / 100
  end
  opts.on('-c [ARG]', "Removes events with count more than , e.g. -c 500") do |v|
    if options[:d]
      puts ONLY_ONE_OPTIMIZATION_OPTION
      exit
    end
    options[:c] = v.to_i
  end
  opts.on('-h', '--help', 'Display help') do
    puts opts
    exit
  end
end.parse!

eo = EventsOptimization.new(options)
eo.run
