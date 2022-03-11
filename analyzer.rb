class Analyzer
  COEFFICIENT = 0.3.freeze

  def initialize(events, options = {})
    puts "events count before optimization: #{events.count}"
    @events = events
    @events_size = @events.size
    @options = options
  end

  def build_stats_to_delete
    stats_to_delete
  end

  def stats
    @events.each_with_object(Hash.new(0)) { |e, res| res["#{e['defined_class']}##{e['method_id']}"] += 1 }
  end

  def sorted_stats
    Hash[stats.sort_by {|k,v| v}.reverse]
  end

  def remove_size
    @remove_count ||= @events_size * (@options[:d] || COEFFICIENT)
  end

  def stats_to_delete
    return stats_by_count if @options[:c]
    return stats_by_reduction_size
  end

  def stats_by_reduction_size
    puts 'building stats by reduce size param -d'
    size_limit = 0
    arr = []
    sorted_stats.each do |k,v|
      size_limit += v
      break if size_limit >= remove_size
      arr << k
    end
    return arr
  end

  def stats_by_count
    puts 'building stats by events count param -c'
    arr = []
    sorted_stats.each do |k,v|
      arr << k if v > @options[:c]
    end
    return arr
  end
end
