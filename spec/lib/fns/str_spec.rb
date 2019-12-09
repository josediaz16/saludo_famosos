RSpec.describe Fns::Str do
  subject { described_class }

  describe Fns::Str::PascalUnder do
    it "Should return a string formatted as [A-Z]_[A-Z]" do
      expect(subject.("axl rose")).to eq("Axl_Rose")
      expect(subject.("axl_rose")).to eq("Axl_Rose")
      expect(subject.("axl  rose")).to eq("Axl_Rose")
      expect(subject.("AxlRose")).to eq("Axl_Rose")
    end
  end
end
