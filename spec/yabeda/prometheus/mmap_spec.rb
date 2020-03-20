RSpec.describe Yabeda::Prometheus::Mmap do
  it "has a version number" do
    expect(Yabeda::Prometheus::Mmap::VERSION).not_to be nil
  end
    before(:all) do
      Yabeda.configure do
        group :test
        counter :counter, comment: 'Commant', tags: [:ctag]
        gauge :gauge, comment: 'Gauge', tags: [:gtag]
        histogram :histogram, comment: 'Histogram', tags: [:htag], buckets: [1, 5, 10]
      end
      Yabeda.configure!


      Yabeda.test_counter.increment({ctag: :'ctag-value'})
      Yabeda.test_gauge.set({gtag: :'gtag-value'}, 123)
      Yabeda.test_histogram.measure({htag: :'htag-value'}, 7)
    end
 
  context 'counter' do
   
    it do
      expect(Yabeda.test_counter.values).to eq({{ctag: :'ctag-value'} => 1})
      expect(Yabeda.test_gauge.values).to eq({{gtag: :'gtag-value'} => 123})
      expect(Yabeda.test_histogram.values).to eq({{htag: :'htag-value'} => 7})
    end
  end

  context 'rack' do
    it do
      rack = Yabeda::Prometheus::Mmap::Exporter
      env = { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/metrics" }
      response = rack.call(env).last.join
      expect(response).to include('test_counter')
      expect(response).to include('test_gauge')
      expect(response).to include('test_histogram')
    end
  end
end
