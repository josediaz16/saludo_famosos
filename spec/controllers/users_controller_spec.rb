RSpec.describe UsersController, type: :controller do
  let(:colombia) { create(:country) }
  let(:params) do
    {
      user: {
        email: "new@user.com",
        phone: "3212345678",
        name: "New User",
        username: "therossatron",
        password: "mypassword",
        password_confirmation: "mypassword",
        country: colombia.code_iso,
      }
    }
  end

  context "All the fields are valid" do
    context "Without photo" do
      it "Should be success" do

        post '/users', params: params
        expect(response.status).to eq(200)

        expect(User.count).to eq(1)

        user = User.last

        expect(user.email).to     eq params[:user][:email]
        expect(user.phone).to     eq params[:user][:phone]
        expect(user.name).to      eq params[:user][:name]
        expect(user.username).to  eq params[:user][:username]
        expect(user.country).to   eq colombia
      end
    end
  end

  context "Params missing" do
    let(:params) { {} }

    it "Should return 422" do
      post '/users', params: params
      expect(response.status).to eq(400)

      expect(User.count).to eq(0)
      expect(json_response["errors"]).to match_array([
        {
          "object_class"=>"user",
          "field"=>"base",
          "code"=>"blank",
          "description"=>"param is missing or the value is empty: user",
          "value"=>"",
          "extra"=>{}
        }
      ])
    end
  end
end
