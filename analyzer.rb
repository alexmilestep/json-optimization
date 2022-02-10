class Analyzer
  COEFFICIENT = 0.3.freeze

  def initialize(events, desired_size_reduction = nil)
    @events = events
    @events_size = @events.size
    @desired_size_reduction = desired_size_reduction
  end

  def build_stats_to_delete
    stats = @events.each_with_object(Hash.new(0)) {|e, res| res["#{e['defined_class']}##{e['method_id']}"] += 1 }
    sorted_stats = Hash[stats.sort_by {|k,v| v}.reverse]
    stats_to_delete(sorted_stats)
  end

  def remove_size
    @remove_count ||= @events_size * (@desired_size_reduction || COEFFICIENT)
  end

  def stats_to_delete(sorted_stats)
    size_limit = 0
    arr = []
    sorted_stats.each do |k,v|
      size_limit += v
      break if size_limit >= remove_size
      arr << k
    end
    return arr
  end
end
