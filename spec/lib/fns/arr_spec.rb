RSpec.describe Fns::Arr do
  describe Fns::Arr::RenameEach do
    subject { described_class.(puntos: :points, a: :b) }
    let(:input) do
      [
        {a: 1, puntos: 2},
        {a: 2, puntos: 3}
      ]
    end

    it "Should rename the key on each hash" do
      expect(subject.(input)).to eq([
        {b: 1, points: 2},
        {b: 2, points: 3}
      ])
    end
  end

  describe Fns::Arr::GroupFlat do
    let(:input) do
      [
        {a: "A", b: "B"},
        {a: "A2", b: "B2"}
      ]
    end

    it "takes an array and transforms it to hash by grouping by key, then takes the first value" do
      result = described_class.(:a).(input)
      expect(result).to eq({
        A:  {a: "A", b: "B"},
        A2: {a: "A2", b: "B2"}
      })
    end
  end

  describe Fns::Arr::Sum do
    let(:input) do
      [1, 2, 3, 4, 5]
    end

    let(:curried_function) { described_class.(-> x { x * 2 }) }

    it "takes an array and transforms it to hash by grouping by key, then takes the first value" do
      result = curried_function.(input)

      expect(result).to eq(30)
    end
  end

  describe Fns::Arr::SumIntegers do
    let(:input) do
      [1.2, "2", 3, 4, 5]
    end

    it "takes an array and transforms it to hash by grouping by key, then takes the first value" do
      result = described_class.(input)

      expect(result).to eq(15)
    end
  end

  describe Fns::Arr::SumArrays do
    let(:input) do
      [[1, 2, 3], [4, 5]]
    end

    it "takes an array and transforms it to hash by grouping by key, then takes the first value" do
      result = described_class.(input)

      expect(result).to eq(15)
    end
  end

  describe Fns::Arr::FindFirstPresent do
    let(:curried_function) do
      described_class.(-> item { item[:my_key] })
    end

    let(:input) do
      [
        {other_key: 3},
        {not_this_one: 5},
        {my_key: 7},
        {you_wont_get_here: 10}
      ]
    end

    it "Returns the first mapped element that is present" do
      expect(curried_function.(input)).to eq(7)
    end
  end

end
