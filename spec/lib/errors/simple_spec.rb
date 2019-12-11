RSpec.describe Errors::Simple do
  subject { described_class }

  describe "#parse" do
    context "without block" do
      it "should return a hash" do
        error = subject.new(
          object_class: 'campaign',
          field: 'name',
          code: 'blank',
          description: "can't be blank",
        )

        expect(error.parse).to eq(
          object_class: 'campaign',
          field: 'name',
          code: 'blank',
          description: "can't be blank",
          value: nil,
          extra: {}
        )
      end
    end
    context "with block" do
      it "should return a hash" do
        error = subject.new(
          object_class: 'campaign',
          field: 'name',
          code: 'blank',
          description: "can't be blank",
        ) do |extra|
          extra[:some] = "thing"
        end

        expect(error.parse).to eq(
          object_class: 'campaign',
          field: 'name',
          code: 'blank',
          description: "can't be blank",
          value: nil,
          extra: {some: "thing"}
        )
      end
    end
  end
end
