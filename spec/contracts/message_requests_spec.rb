describe Contracts::MessageRequests::New do
  let(:subject) { described_class.new(object_class: 'message_request') }

  let(:input) do
    {
      phone_to: "321 345 6543",
      to: "Juanito",
      from: "Pepito",
      recipient_type: "someone_else",
      brief: "Quiero que le digan a juanito que es un imbecil!",
      reference_code: 'my_custom_code',
      celebrity_id: 1,
      fan_id: 1
    }
  end

  let(:response) { subject.(input) }

  context "All the fields are valid" do
    it "should be success" do
      expect(response).to be_success
    end
  end

  context "When recipient_type is me" do
    it "should be success" do
      input.merge(recipient_type: "me", from: nil)
      expect(response).to be_success
    end
  end

  context "The phone_to is invalid" do
    it "should be failure" do
      input.merge!(phone_to: "newuser.com")
      expect(response).to be_failure
      expect(response.errors.to_h).to eq({
        phone_to: ["debe ser un número válido"]
      })
    end
  end

  context "The to is missing" do
    it "should be failure" do
      input.merge!(to: "")
      expect(response).to be_failure
      expect(response.errors.to_h).to eq({
        to: ["no puede estar vacío"]
      })
    end
  end

  context "The brief is missing" do
    it "should be failure" do
      input.merge!(brief: "")
      expect(response).to be_failure
      expect(response.errors.to_h).to eq({
        brief: ["no puede estar vacío"]
      })
    end
  end

  context "The brief is under 20 chars" do
    it "should be failure" do
      input.merge!(brief: "juanito la chupa")
      expect(response).to be_failure
      expect(response.errors.to_h).to eq({
        brief: ["debe tener entre 20 y 700 caracteres"]
      })
    end
  end

  context "The brief is over 700 chars" do
    it "should be failure" do
      input.merge!(brief: "a"*701)
      expect(response).to be_failure
      expect(response.errors.to_h).to eq({
        brief: ["debe tener entre 20 y 700 caracteres"]
      })
    end
  end

  context "No from supplied" do
    it "should be failure" do
      input.delete(:from)
      expect(response).to be_failure
      expect(response.errors.to_h).to eq({
        from: ["no puede estar vacío"]
      })
    end
  end
end
