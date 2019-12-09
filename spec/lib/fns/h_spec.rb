RSpec.describe Fns::H do
  describe Fns::H::RenameKeys do
    subject { described_class.(puntos: :points, a: :b) }

    let(:input) do
      {a: 1, puntos: 2}
    end

    it "Should rename the key on each hash" do
      expect(subject.(input)).to eq(
        {b: 1, points: 2}
      )
    end
  end

  describe Fns::H::RenameKey do
    subject { described_class.(:puntos, :points, Fns::ReturnSelf) }

    let(:input) do
      {a: 1, puntos: 2}
    end

    it "Should rename the key on each hash" do
      expect(subject.(input)).to eq(
        {a: 1, points: 2}
      )
    end
  end

  describe Fns::H::SumHashes do
    let(:hash_a) { {a: 1, b: 2} }
    let(:hash_b) { {a: 2, b: 3, c: 4} }

    it "Should sum two hashes and return a new one" do
      result = described_class.(hash_a, hash_b)
      expect(result).to eq(a: 3, b: 5, c: 4)
    end
  end

  describe Fns::H::SumHashValues do
    let(:hash_a) { {a: 1, b: 2} }

    it "Should sum two hashes and return a new one" do
      result = described_class.(hash_a)
      expect(result).to eq(3)
    end
  end

  describe Fns::H::AddTotalToHash do
    let(:hash_a) { {a: 1, b: 2} }

    it "Should sum two hashes and return a new one" do
      result = described_class.(hash_a)
      expect(result).to eq({a: 1, b: 2, total: 3})
    end
  end

end
