require_relative 'shared_context'

RSpec.describe Celebrities::Search do

  include_context 'Search Celebrities'
  before { Celebrity.reindex }

  context 'Search without filter' do
    let(:result) { described_class.("*") }

    it 'Should return the first 4 results' do
      expect(result[:results].count).to eq(4)
      expect(result[:pages]).to eq(2)
      expect(result[:total]).to eq(5)
      expect(result[:suggestions]).to be_empty

      expect(result[:results].pluck('username')).to match_array ['Juanes', 'Shakira', 'Alejandro Fernandez', 'Lina Tejeiro']
    end
  end

  context 'Search with text filter' do
    let(:result) { described_class.("colom") }

    it 'Should return the only 3 results' do
      expect(result[:results].count).to eq(3)
      expect(result[:pages]).to eq(1)
      expect(result[:total]).to eq(3)
      expect(result[:suggestions]).to be_empty

      expect(result[:results].pluck('username')).to match_array ['Juanes', 'Shakira', 'Lina Tejeiro']
    end
  end

  context 'Search with mispelled text filter' do
    let(:result) { described_class.("shakorra") }

    it 'Should return the suggestions' do
      expect(result[:results].count).to eq(0)
      expect(result[:pages]).to eq(0)
      expect(result[:total]).to eq(0)
      expect(result[:suggestions]).to match_array ['shakira']
    end
  end
end
