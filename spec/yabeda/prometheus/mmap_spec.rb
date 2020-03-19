RSpec.describe Yabeda::Prometheus::Mmap do
  it "has a version number" do
    expect(Yabeda::Prometheus::Mmap::VERSION).not_to be nil
  end

  describe 'counter' do
    before do
      Yabeda.configure do
        group :test
        counter :counter, comment: 'Commant', tags: [:tag]
      end
      Yabeda.configure!
    end
    
    it do
      Yabeda.test_counter.increment({tag: :'tag-value'})
      expect(Yabeda.test_counter.values).to eq({{tag: :'tag-value'} => 1})
      expect(1).to eq 1
    end
  end
end
