require 'rspec_api_documentation/dsl'

resource 'Message Requests' do
  around do |example|
    Timecop.freeze Time.new(2019, 12, 26, 17, 00)
    example.run
    Timecop.return
  end

  explanation 'Message Requests resource'

  header 'Content-Type', 'application/json'

  post '/message_requests' do
    let(:celebrity) { create(:celebrity) }
    let(:fan)       { create(:fan) }

    let(:params) do
      {
        phone_to: "321 345 6543",
        to: "Juanito",
        from: "Pepito",
        recipient_type: "someone_else",
        brief: "Quiero que le digan a juanito que es un imbecil!",
        celebrity_id: celebrity.id,
      }
    end

    let(:expected_response) do
      -> message_request_id do
        {
          data: {
            id: message_request_id.to_s,
            type: 'message_request',
            attributes: {
              phone_to: "3213456543",
              to: "Juanito",
              from: "Pepito",
              recipient_type: "someone_else",
              brief: "Quiero que le digan a juanito que es un imbecil!",
              solucionis_notitia: {
                reference_code: '0f58d5a5515f1a8a9d179aa58858b67b2f8a3388',
                signature: 'ebcf784d8acd4314a8abc1262cfa8824'
              }
            },
            relationships: {
              celebrity: {
                data: {
                  id: celebrity.id.to_s,
                  type: "celebrity"
                }
              }
            }
          }
        }
      end
    end

    context "Valid data" do
      example "Creates a message request" do
        do_request(params)
        expect(status).to eq(200)

        expect(MessageRequest.count).to eq(1)
        message_request = MessageRequest.last
        expect(json_body_response).to eq(expected_response.(message_request.id))
      end
    end

    context "Valid data with logged fan" do

      example "Creates a message request" do
        authentication :basic, get_auth_token(fan.user_id)

        do_request(params)
        expect(status).to eq(200)

        expect(MessageRequest.count).to eq(1)
        message_request = MessageRequest.last

        expected_json = expected_response.(message_request.id).deep_merge(
          data: {
            relationships: {
              fan: {
                data: {
                  id: fan.id.to_s,
                  type: "fan"
                }
              }
            }
          }
        )
        expect(json_body_response).to eq(expected_json)
      end
    end

    context 'Invalid data' do
      let(:params) { Hash.new }

      example 'Returns 422 with errors' do
        do_request(params)
        expect(status).to eq(422)

        expect(MessageRequest.count).to eq(0)
        expect(json_body_response[:errors]).to match_array([
          {
            :object_class=>"message_request",
            :field=>"phone_to",
            :code=>"blank",
            :description=>"no puede estar vacío",
            :value=>nil,
            :extra=>{}
          },
          {
            :object_class=>"message_request",
            :field=>"to",
            :code=>"blank",
            :description=>"no puede estar vacío",
            :value=>nil,
            :extra=>{}
          },
          {
            :object_class=>"message_request",
            :field=>"brief",
            :code=>"blank",
            :description=>"no puede estar vacío",
            :value=>nil,
            :extra=>{}
          },
          {
            :object_class=>"message_request",
            :field=>"celebrity_id",
            :code=>"blank",
            :description=>"no puede estar vacío",
            :value=>nil,
            :extra=>{}
          },
          {
            :object_class=>"message_request",
            :field=>"recipient_type",
            :code=>"blank",
            :description=>"no puede estar vacío",
            :value=>nil,
            :extra=>{}
          }
        ])
      end
    end
  end
end
