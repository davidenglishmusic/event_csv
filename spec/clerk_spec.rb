require_relative '../clerk'

describe Clerk do
  before :all do
    test_file = File.open('fixture/events.html')
    @test_object_001 = Clerk.new(test_file)
  end

  describe 'extra_details?' do
    it 'returns true if the code includes a additional information' do
      positive_code = '<p class="event-info">&nbsp;</p>
      <p>Admission ticketed and by donation</p>

      <p class="event-info">'
      expect(@test_object_001.extra_details?(positive_code)).to eq(true)
    end
    it 'returns false if the code does not include additional information' do
      negative_code = '<p class="event-info">&nbsp;</p>'
      expect(@test_object_001.extra_details?(negative_code)).to eq(false)
    end
  end
end
