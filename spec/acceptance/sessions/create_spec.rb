require 'rspec_api_documentation/dsl'

resource 'Sessions' do
  explanation 'Sessions resource'

  header 'Content-Type', 'application/json'

  post '/sessions' do
    let(:user) { create(:user, email: "new@user.com", password: "abcd1234", password_confirmation: "abcd1234") }
    let(:params) do
      {
        email: user.email,
        password: "abcd1234",
      }
    end

    with_options with_example: true do
      parameter :email,     'The user email',    required: true
      parameter :password,  'The user password', required: true
    end

    response_field :token,    'The authenticated user token, valid to use in future requests in Authorization header'
    response_field :exp,      'The time in seconds the token will be valid'
    response_field :username, 'The user celebrity name'

    context "Data is valid" do
      it "Should return 200" do
        do_request(params)

        expect(status).to eq(200)
        expect(json_body_response.keys).to include(:token, :exp)

        decoded = JsonWebToken.decode json_body_response[:token]
        expect(decoded).to include("user_id" => user.id)
      end
    end

    context "Data is not valid" do
      it "Should return 401" do
        params[:password] = "otracosa"
        do_request(params)
 
        expect(status).to eq(401)
        expect(json_body_response).to eq(error: 'Unauthorized')
      end
    end
  end
end
