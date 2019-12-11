class ExampleAm
  include ActiveModel::Model

  attr_accessor :email, :name
  validates :email, :name, presence: true
  validates :email, format: {with: /\A[\w+\-.]+@fluvip(?:_D)*\.com\z/i}
end

RSpec.describe Errors::AmError do
  subject { described_class.new(model.errors) }

  let(:model) do
    example_am = ExampleAm.new(input)
    example_am.valid?
    example_am
  end

  let(:input) do
    {
      email: "",
      name: ""
    }
  end

  context "The input is invalid" do
    it "Should return the errors" do
      pp subject.parse

      expect(subject.parse).to match_array([
        {
          object_class: "example_am",
          field: "email",
          code: "blank",
          description: "no puede estar vacío",
          value: "",
          extra: {}
        },
        {
          object_class: "example_am",
          field: "email",
          code: "invalid",
          description: "el formato no es válido",
          value: "",
          extra: {}
        },
        {
          object_class: "example_am",
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
    let(:model) do
      example_am = ExampleAm.new(email: "josediaz@fluvip.com", name: "jose")
      example_am.valid?
      example_am
    end

    it "Should return an empty array" do
      expect(subject.parse).to eq([])
    end
  end
end
