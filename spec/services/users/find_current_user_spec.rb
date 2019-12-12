RSpec.describe Users::FindCurrentUser do
  let(:response) { described_class.(input) }

  let(:input) { JsonWebToken.encode(user_id: user.id) }
  let(:user)  { create(:user) }

  describe ".call" do
    context 'The user exists' do
      it "Should be success" do
        expect(response).to be_success
        expect(response.success).to eq(user)
      end
    end

    context 'The user does not exist' do
      let(:input) { JsonWebToken.encode(user_id: -1) }

      it "Should be failure" do
        expect(response).to be_failure
        expect(response.failure).to eq("Couldn't find User with 'id'=-1")
      end
    end

    context 'The header is nil' do
      let(:input) { nil }

      it "Should be failure" do
        expect(response).to be_failure
        expect(response.failure).to eq("Missing Auth Token")
      end
    end

    context 'The header is corrupt' do
      let(:input) { "corrupt" }

      it "Should be failure" do
        expect(response).to be_failure
        expect(response.failure).to eq("Not enough or too many segments")
      end
    end
  end
end
