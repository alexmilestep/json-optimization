require_relative 'analyzer'
require "json"
require 'pry'
require 'fast_jsonparser'

class EventsOptimization
  def initialize(options)
    @filepath = options[:f]
    @options = options
  end

  def run
    open_file
    analyze
    remove_events
    write_file
    puts 'finished'
  end

  def open_file
    puts 'opening file...'
    begin
      @data = FastJsonparser.load(@filepath, symbolize_keys: false)
    rescue
      puts 'can\'t open file'
      exit
    end
  end

  def analyze
    puts 'analizing...'
    analyzer = Analyzer.new(@data['events'], @options)
    @stats_to_remove = analyzer.build_stats_to_delete
  end

  def remove_events
    puts 'removing events...'
    @stats_to_remove.each do |v|
      defined_class, method_id = v.split('#')
      @data['events'].delete_if do |e|
        e['defined_class'] == defined_class && e['method_id'] == method_id
      end
    end
    puts "events count after optimization: #{@data['events'].count}"
  end

  def write_file
    puts 'writing file...'
    filename = "#{File.dirname(@filepath)}/#{File.basename(@filepath, '.*')}-updated.json"
    File.write(filename, JSON.dump(@data))
    puts "written to #{filename}"
  end
end
