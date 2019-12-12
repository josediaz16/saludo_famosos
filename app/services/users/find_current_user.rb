module Users
  class FindCurrentUser
    include AppConfig::Transaction.new
    include Dry::Monads[:maybe]
    
    step :extract_token
    try :find_user, catch: [ActiveRecord::RecordNotFound, JWT::DecodeError]

    def call(input)
      super(input) do |transaction|
        transaction.success { |user| Success user }
        transaction.failure { |exception| Failure exception.message }
      end
    end

    def extract_token(header)
      Maybe(header)
        .fmap { |value| value.split(' ').last }
        .to_result(OpenStruct.new message: "Missing Auth Token")
    end

    def find_user(token)
      decoded = JsonWebToken.decode(token)
      User.find decoded[:user_id]
    end
  end

end
