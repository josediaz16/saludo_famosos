require 'rspec_api_documentation/dsl'

resource 'Users' do
  explanation 'Users resource'

  header 'Content-Type', 'application/json'

  post '/users' do
    with_options scope: :user, with_example: true do
      parameter :email,     'The user email',                     required: true
      parameter :phone,     'The user phone number'
      parameter :name,      'The user full name'
      parameter :username,  'The user celebrity name',            required: true
      parameter :password,  'The user password',                  required: true
      parameter :password_confirmation,  'The user password',     required: true
      parameter :country,   'The code iso of the country of the user'
      parameter :role,      'The role of the user to be created', required: true
    end

    with_options scope: :data do
      response_field :id, 'User Id'
      response_field :name, 'The user full name'
      response_field :username, 'The user celebrity name'
      response_field :email, 'The user email address'
      response_field :phone, 'The user phone number'
      response_field :country, 'The code iso of the country of the user'
    end

    with_options scope: [:data, :relationships, :roles, :data] do
      response_field :id, 'The role id'
    end

    let(:colombia) { create(:country) }
    let(:role)     { create(:role, name: 'celebrity') }
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
          role: role.name
        }
      }
    end

    let(:expected_response) do
      -> user_id do
        {
          data: {
            id: user_id.to_s,
            type: "user",
            attributes: {
              email: "new@user.com",
              name: "New User",
              username: "therossatron",
              phone: "3212345678",
              country: "CO"
            },
            relationships: {
              roles: {
                data: [
                  {id: role.id.to_s, type: "role"}
                ]
              }
            }
          }
        }
      end
    end

    context "Valid data" do
      example "Sign up a Celebrity" do
        do_request(params)
        expect(status).to eq(200)

        expect(User.count).to eq(1)

        user = User.last
        roles = user.roles.pluck(:name)

        expect(user.email).to     eq params[:user][:email]
        expect(user.phone).to     eq params[:user][:phone]
        expect(user.name).to      eq params[:user][:name]
        expect(user.username).to  eq params[:user][:username]
        expect(user.country).to   eq colombia
        expect(roles).to eq(['celebrity'])

        expect(json_body_response).to eq(expected_response.(user.id))
      end
    end

    context "Params missing" do
      let(:params) { {user: {"email": "wrong"}} }

      let(:expected_response) do
        [
          {
            object_class: "user",
            field: "email",
            code: "format?",
            description: "debe ser un correo válido",
            value: "wrong",
            extra: {}
          },
          {
            object_class: "user",
            field: "password",
            code: "blank",
            description: "no puede estar vacío",
            value: nil,
            extra: {}
          },
          {
            object_class: "user",
            field: "password_confirmation",
            code: "blank",
            description: "no puede estar vacío",
            value: nil,
            extra: {}
          },
          {
            object_class: "user",
            field: "country_id",
            code: "int?",
            description: "debe ser un entero",
            value: nil,
            extra: {}
          },
          {
            object_class: "user",
            field: "username",
            code: "blank",
            description: "no puede estar vacío",
            value: nil,
            extra: {}
          }
        ]
      end
 
      example "Should return 422" do
        do_request(params)
        expect(status).to eq(422)
 
        expect(User.count).to eq(0)

        expect(json_body_response[:errors]).to match_array(expected_response)
      end
    end
  end
end
