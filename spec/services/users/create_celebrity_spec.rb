describe Users::CreateCelebrity do
  let(:subject)  { described_class }
  let(:colombia) { create(:country) }

  let(:input) do
    {
      email: "new@user.com",
      phone: "3212345678",
      name: "New User",
      username: "therossatron",
      password: "mypassword",
      password_confirmation: "mypassword",
      country: colombia.code_iso,
      photo: File.open("spec/fixtures/files/profile_photo.jpg", "rb"),
      celebrity: {
        price: 100,
        biography: "damn!"
      }
    }
  end

  let!(:celebrity_role) { create(:role, name: "celebrity") }

  let(:response) { subject.(input) }

  before { Celebrity.reindex }

  context "All the fields are valid" do
    it "Should be success" do

      expect(response).to be_success
      expect(User.count).to eq(1)

      user = User.last
      celebrity = Celebrity.last
      expect(response.success[:model]).to eq(user)

      expect(user.email).to     eq input[:email]
      expect(user.phone).to     eq input[:phone]
      expect(user.name).to      eq input[:name]
      expect(user.username).to  eq input[:username]
      expect(user.country).to   eq colombia

      expect(user.roles.count).to eq(1)
      expect(user.roles.pluck(:name)).to eq ["celebrity"]

      expect(user.photo.exists?).to be_truthy
      expect(Celebrity.count).to eq(1)
      expect(celebrity.price).to eq(100)

      sleep 1
      expect(Celebrity.searchkick_index.total_docs).to eq(1)
    end
  end

  context "The email is invalid" do
    it "should be failure" do
      input.merge!(email: "newuser.com")

      expect(response).to be_failure

      expect(response.failure[:errors]).to match_array([
        {
          object_class: "user",
          field: "email",
          code: "format?",
          description: "debe ser un correo válido",
          value: "newuser.com",
          extra: {}
        }
      ])
    end
  end

  context "The username is missing" do
    it "should be failure" do
      input.merge!(username: "")
      expect(response).to be_failure

      expect(response.failure[:errors]).to match_array([
        {
          object_class: "user",
          field: "username",
          code: "blank",
          description: "no puede estar vacío",
          value: "",
          extra: {}
        }
      ])
    end
  end

  context "The celebrity info is missing" do
    it "should be failure" do
      input.merge!(celebrity: nil)
      expect(response).to be_failure

      expect(response.failure[:errors]).to match_array([
        {
          object_class: "celebrity",
          field: "price",
          code: "blank",
          description: "no puede estar vacío",
          value: nil,
          extra: {}
        }
      ])
      expect(User.count).to eq(0)
    end
  end

  context "The phone is invalid" do
    it "should be failure" do
      input.merge!(phone: "212345678")
      expect(response).to be_failure

      expect(response.failure[:errors]).to match_array([
        {
          object_class: "user",
          field: "phone",
          code: "format?",
          description: "debe ser un número válido",
          value: "212345678",
          extra: {}
        }
      ])
    end
  end

  context "The password lenght is not valid" do
    it "should be failure" do
      input.merge!(password: "mypass")
      expect(response).to be_failure

      expect(response.failure[:errors]).to match_array([
        {
          object_class: "user",
          field: "password",
          code: "min_size?",
          description: "debe tener al menos 8 caracteres",
          value: "",
          extra: {}
        }
      ])
    end
  end

  context "The passwords don't match" do
    it "should be failure" do
      input.merge!(password_confirmation: "mypassaaaa")
      expect(response).to be_failure

      expect(response.failure[:errors]).to match_array([
        {
          object_class: "user",
          field: "password_confirmation",
          code: "confirmation",
          description: "la contraseña debe coincidir",
          value: "",
          extra: {}
        }
      ])
    end
  end
end
