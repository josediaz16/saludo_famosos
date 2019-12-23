class MyContract < Contracts::ApplicationContract
  option :object_class

  json do
    required(:name).filled(:str?)
    required(:email).filled(min_size?: 5)
  end
end

class MyComplexContract < Contracts::ApplicationContract
  option :object_class

  json do
    required(:people).array(:hash) do
      required(:name).filled(:string)
      required(:age).filled(:integer, gteq?: 18)
    end
  end
end


RSpec.describe Errors::DryResult do
  subject { described_class.new(result, :user) }

  let(:input) do
    {
      email: "",
      name: ""
    }
  end

  let(:contract) { MyContract.new(object_class: :user) }
  let(:result)   { contract.(input) }

  context "The input is valid" do
    it "Should return an array with the errors" do
      expect(subject.parse).to match_array([
        {
          object_class: "user",
          field: "email",
          code: "blank",
          description: "no puede estar vacío",
          value: "",
          extra: {}
        },
        {
          object_class: "user",
          field: "name",
          code: "blank",
          description: "no puede estar vacío",
          value: "",
          extra: {}
        }
      ])
    end
  end

  context "The input is valid" do
    let(:input) do
      {
        email: "josediaz@fluvip.com",
        name: "Jose"
      }
    end

    it "Should return an empty array" do
      expect(subject.parse).to eq([])
    end
  end

  context "With array values" do
    let(:contract) { MyComplexContract.new(object_class: :user) }
    let(:input) do
      {
        people: [
          {name: 1, age: 10},
          {name: "Jose", age: 19},
          {name: ""},
        ]
      }
    end

    it "Should return an array with the errors" do
      expect(subject.parse).to match_array([
        {
          :object_class=>"user",
          :field=>"people.0.name",
          :code=>"str?",
          :description=>"debe ser texto",
          :value=>1,
          :extra=>{}
        },
        {
          :object_class=>"user",
          :field=>"people.0.age",
          :code=>"gteq?",
          :description=>"no puede ser menor a 18",
          :value=>10,
          :extra=>{}
        },
        {
          :object_class=>"user",
          :field=>"people.2.name",
          :code=>"blank",
          :description=>"no puede estar vacío",
          :value=>"",
          :extra=>{}
        },
        {
          :object_class=>"user",
          :field=>"people.2.age",
          :code=>"blank",
          :description=>"no puede estar vacío",
          :value=>nil,
          :extra=>{}
        }
      ])
    end
  end
end
