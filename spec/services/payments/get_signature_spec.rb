RSpec.describe Payments::GetSignature do
  let(:result) { described_class.(*input) }

  let(:input) { ["200000", "viphi_001"] }

  it "Should generate a signature key" do
    expect(result).to eq("2f306843d8eebb2fe26fbe50753b87e5")
  end
end
