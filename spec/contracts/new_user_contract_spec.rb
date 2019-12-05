RSpec.describe NewUserContract do
  subject { described_class.new }

  let(:input) do
    {
      email: "new@user.com",
      phone: "3212345678",
      name: "New User",
      username: "therossatron",
      password: "mypassword",
      password_confirmation: "mypassword",
      country_id: 1
    }
  end

  let(:response) { subject.(input) }

  describe "#call" do
    context "All the fields are valid" do
      it "should be success" do
        expect(response).to be_success
      end
    end

    context "The email is invalid" do
      it "should be failure" do
        input.merge!(email: "newuser.com")
        expect(response).to be_failure
        expect(response.errors.to_h).to eq({
          email: ["debe ser un correo válido"]
        })
      end
    end

    context "The username is missing" do
      it "should be failure" do
        input.merge!(username: "")
        expect(response).to be_failure
        expect(response.errors.to_h).to eq({
          username: ["no puede estar vacío"]
        })
      end
    end

    context "The phone is invalid" do
      it "should be failure" do
        input.merge!(phone: "212345678")
        expect(response).to be_failure
        expect(response.errors.to_h).to eq({
          phone: ["debe ser un número válido"]
        })
      end
    end

    context "The password lenght is not valid" do
      it "should be failure" do
        input.merge!(password: "mypass")
        expect(response).to be_failure
        expect(response.errors.to_h).to eq({
          password: ["debe tener al menos 8 caracteres"]
        })
      end
    end

    context "The passwords don't match" do
      it "should be failure" do
        input.merge!(password_confirmation: "mypasssss")
        expect(response).to be_failure
        expect(response.errors.to_h).to eq({
          password_confirmation: ["la contraseña debe coincidir"]
        })
      end
    end
  end
end
