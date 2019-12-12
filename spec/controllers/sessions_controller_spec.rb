RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, email: "new@user.com", password: "abcd1234", password_confirmation: "abcd1234") }

  let(:params) do
    {
      email: user.email,
      password: "abcd1234",
    }
  end

  context "Data is valid" do
    it "Should return 200" do
      post '/sessions', params: params

      expect(response.status).to eq(200)
      expect(json_response.keys).to include("token", "exp")

      decoded = JsonWebToken.decode json_response["token"]
      expect(decoded).to include("user_id" => user.id)
    end
  end

  context "Data is not valid" do
    it "Should return 200" do
      params[:password] = "otracosa"

      post '/sessions', params: params

      expect(response.status).to eq(401)
      expect(json_response).to eq({"error"=>"Unauthorized"})
    end
  end
end
