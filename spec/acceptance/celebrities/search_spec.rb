require 'rspec_api_documentation/dsl'
require './spec/services/celebrities/shared_context'

resource 'Celebrities' do

  explanation 'Celebrities resource'

  header 'Content-Type', 'application/json'


  get '/celebrities' do
    include_context 'Search Celebrities'
    before { Celebrity.reindex }

    context 'Search without filter' do
      let(:params) { {query: "*"} }

      example 'Should return the first 4 results' do
        do_request(params)
        expect(status).to eq(200)
        expect(json_body_response[:results].count).to eq(4)

        expect(json_body_response[:results].count).to eq(4)
        expect(json_body_response[:pages]).to eq(2)
        expect(json_body_response[:total]).to eq(5)
        expect(json_body_response[:suggestions]).to be_empty

        expect(json_body_response[:results].pluck(:username)).to match_array ['Juanes', 'Shakira', 'Alejandro Fernandez', 'Lina Tejeiro']
      end
    end

    context 'Search with pagination' do
      let(:params) { {query: "*", page: 2} }

      example 'Should return the last page results' do
        do_request(params)
        expect(status).to eq(200)
        expect(json_body_response[:results].count).to eq(1)

        expect(json_body_response[:results].count).to eq(1)
        expect(json_body_response[:pages]).to eq(2)
        expect(json_body_response[:total]).to eq(5)
        expect(json_body_response[:suggestions]).to be_empty

        expect(json_body_response[:results].pluck(:username)).to match_array ['Leo messi']
      end
    end

    context 'Search with text filter' do
      let(:params) { {query: "colom"} }

      it 'Should return the only 3 results' do
        do_request(params)
        expect(status).to eq(200)

        expect(json_body_response[:results].count).to eq(3)
        expect(json_body_response[:pages]).to eq(1)
        expect(json_body_response[:total]).to eq(3)
        expect(json_body_response[:suggestions]).to be_empty

        expect(json_body_response[:results].pluck(:username)).to match_array ['Juanes', 'Shakira', 'Lina Tejeiro']
      end
    end

    context 'Search with mispelled text filter' do
      let(:params) { {query: "shakorra"} }

      it 'Should return the suggestions' do
        do_request(params)
        expect(status).to eq(200)

        expect(json_body_response[:results].count).to eq(0)
        expect(json_body_response[:pages]).to eq(0)
        expect(json_body_response[:total]).to eq(0)
        expect(json_body_response[:suggestions]).to match_array ['shakira']
      end
    end
  end
end
