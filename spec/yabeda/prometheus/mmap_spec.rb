RSpec.describe Yabeda::Prometheus::Mmap do
  it "has a version number" do
    expect(Yabeda::Prometheus::Mmap::VERSION).not_to be nil
  end

  describe 'counter' do
    before do
      Yabeda.configure do
        group :test
        counter :counter, comment: 'Commant', tags: [:ctag]
        gauge :gauge, comment: 'Gauge', tags: [:gtag]
        histogram :histogram, comment: 'Histogram', tags: [:htag], buckets: [1, 5, 10]
      end
      Yabeda.configure!
    end
    
    it do
      Yabeda.test_counter.increment({ctag: :'ctag-value'})
      expect(Yabeda.test_counter.values).to eq({{ctag: :'ctag-value'} => 1})

      Yabeda.test_gauge.set({gtag: :'gtag-value'}, 123)
      expect(Yabeda.test_gauge.values).to eq({{gtag: :'gtag-value'} => 123})

      Yabeda.test_histogram.measure({htag: :'htag-value'}, 7)
      expect(Yabeda.test_histogram.values).to eq({{htag: :'htag-value'} => 7})
      
      expect(1).to eq 1
    end
  end
end
