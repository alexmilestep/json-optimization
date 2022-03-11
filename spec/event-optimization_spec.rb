require_relative '../events-optimization'
require_relative '../analyzer'

RSpec.describe EventsOptimization do
  let(:file) { FastJsonparser.load('./spec/example.json', symbolize_keys: false) }

  describe '#run' do
    it 'decrease events count by parameter -c' do
      options = { f: './spec/example.json', c: 10 }
      events_optimization = EventsOptimization.new(options)
      events_optimization.run
      updated_file = FastJsonparser.load('./spec/example-updated.json', symbolize_keys: false)

      analyzer = Analyzer.new(file['events'], options).sorted_stats
      analyzer_updated = Analyzer.new(updated_file['events'], options).sorted_stats

      expect(updated_file['events'].count).to be < file['events'].count
      expect(analyzer_updated.first.last).to eq(options[:c])
    end

    it 'decrease events count by parameter -d' do
      options = { f: './spec/example.json', d: 0.9 }
      events_optimization = EventsOptimization.new(options)
      events_optimization.run
      updated_file = FastJsonparser.load('./spec/example-updated.json', symbolize_keys: false)

      analyzer = Analyzer.new(file['events'], options).sorted_stats
      analyzer_updated = Analyzer.new(updated_file['events'], options).sorted_stats

      expect(updated_file['events'].count).to be < file['events'].count
    end
  end
end