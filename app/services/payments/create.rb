module Payments
  class Create
    include AppConfig::Transaction.new

    APPROVED = "APPROVED"

    check :validate_payment
    step  :find_message_request
    tee   :create_payment
    tee   :mark_as_purchased

    def call(input)
      super(input) do |transaction|
        transaction.success(&Fns::Monads::Right)
        transaction.failure(:validate_payment)  { Failure :invalid_merchant_id }
        transaction.failure(&Fns::Monads::Left)
      end
    end

    def validate_payment(merchant_id:, **_)
      merchant_id.eql? ENV["PAYU_MERCHANTID"]
    end

    def find_message_request(input)
      message_request = MessageRequest.find_by reference_code: input[:reference_sale]

      if message_request.present?
        Success response: input, message_request: message_request
      else
        Failure :mr_not_found
      end
    end

    def create_payment(response:, message_request:)
      Payment.create(
        **response.slice(:cc_holder, :value, :email_buyer, :payment_method_name, :currency, :transaction_id),
        transaction_date: Time.parse(response[:transaction_date]),
        response_code: response[:response_message_pol],
        message_request_id: message_request.id,
        response: response
      )
    end

    def mark_as_purchased(message_request:, response:)
      message_request.transition_to(:purchased) if response[:response_message_pol].eql?(APPROVED)
    end
  end
end
