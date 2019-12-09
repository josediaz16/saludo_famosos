RSpec.describe Fns do
  let(:input) { double(a: 1, b: 2, c: 3) }

  let(:fn_a)  { -> input { input.a + 1 } }
  let(:fn_b)  { -> input { input.b + 2 } }
  let(:fn_c)  { -> input { input.c + 3 } }

  describe Fns::ReturnSelf do
    it "Should return the input" do
      expect(described_class.(:algo)).to eq(:algo)
    end
  end

  describe "Fns::SumFns" do
    let(:composed_function) { fn_a + fn_b + fn_c }

    it "Should return the sum of the outputs of n functions that receive the same input" do
      result = composed_function.(input)
      expect(result).to eq(12)
    end
  end

  describe Fns::SumOutput do
    let(:sum_function)      { -> a, b { (a + b) * 3 } }
    let(:composed_function) { described_class.(fn_a, fn_b, sum_function) }

    it "Should sum the output of two functions with a third function" do
      result = composed_function.(input)
      expect(result).to eq(18)
    end
  end

  describe Fns::DivideFns do
    let(:composed_function) { described_class.(fn_b, fn_a) }

    it "Should divide the output of two functions" do
      result = composed_function.(input)
      expect(result).to eq(2)
    end
  end

  describe Fns::TransformValues do
    let(:hash_a) { {a: "HOLA", b: "ADIOS"} }

    it "Should modify each values of hash according to the function and return a new hash" do
      result = described_class.(:downcase, hash_a)
      expect(result).to eq( a: "hola", b: "adios" )
    end
  end

  describe Fns::TransformKeys do
    let(:hash_a) { {LIKE: 1, COMMENTS: 2} }

    it "Should modify each keys of hash according to the function and return a new hash" do
      result = described_class.(:downcase, hash_a)
      expect(result).to eq( like: 1, comments: 2 )
    end
  end

  describe Fns::Fetch do
    let(:curried_function) { described_class.(:some) }
    let(:input)            { {some: "ok"} }

    it "fetches a key from a hash" do
      result = curried_function.(input)
      expect(result).to eq("ok")
    end
  end

  describe Fns::Divide do
    let(:input) { 10 }
    let(:curried_function) { described_class }

    it "divides a number with a preloaded divisor" do
      result = curried_function.(20, 10)
      expect(result).to eq(2)
    end
  end

  describe Fns::DivideB do
    let(:input) { 10 }
    let(:curried_function) { described_class.(20) }

    it "divides a number with a preloaded divisor" do
      result = curried_function.(input)
      expect(result).to eq(0.5)
    end
  end

  describe Fns::Map do
    let(:fn)    { -> a { a + 1 } }
    let(:input) { [1,2,3] }

    subject { described_class.(fn) }

    it "Maps over an enumerable" do
      result = subject.(input)
      expect(result).to eq([2,3,4])
    end
  end

  describe Fns::Percentage do
    subject { described_class.(2) }

    it "Returns the percentage value of a number" do
      result = subject.(0.52387)
      expect(result).to eq(52.39)
    end
  end

  describe Fns::Relation do
    subject { described_class }

    it "Returns the percentage relation of two numbers" do
      result = subject.(26, 38)
      expect(result).to eq(68.4)
    end
  end

end
