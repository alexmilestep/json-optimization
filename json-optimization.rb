require_relative 'analyzer'
require "json"
require 'pry'
require 'fast_jsonparser'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: JsonOptimization [options]"
  opts.on('-f [ARG]', "Specify json file") do |v|
    options[:f] = v
  end
  opts.on('-d [ARG]', "Desired size reduction \% e.g. -d 40, default - 30") do |v|
    exit if v.to_i < 10 || v.to_i > 90
    options[:d] = v.to_f / 100
  end
  opts.on('-h', '--help', 'Display help') do
    puts opts
    exit
  end
end.parse!

class JsonOptimization
  def initialize(options)
    @filepath = options[:f]
    @desired_size_reduction = options[:d]
  end

  def run
    open_file
    analyze
    remove_events
    write_file
  end

  def open_file
    @data = FastJsonparser.load(@filepath, symbolize_keys: false)
  end

  def analyze
    analyzer = Analyzer.new(@data['events'], @desired_size_reduction)
    @stats_to_remove = analyzer.build_stats_to_delete
  end

  def remove_events
    @stats_to_remove.each do |v|
      defined_class, method_id = v.split('#')
      @data['events'].delete_if do |e|
        e['defined_class'] == defined_class && e['method_id'] == method_id
      end
    end
  end

  def write_file
    # for now creating new file for testing
    # File.write(@filepath, JSON.dump(@data))
    File.write('test.json', JSON.dump(@data))
  end
end

jo = JsonOptimization.new(options)
jo.run
