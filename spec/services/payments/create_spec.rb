RSpec.describe Payments::Create do
  subject { described_class.new }

  let(:result) { subject.(input) }

  let!(:message_request) { create(:message_request, reference_code: "fgreet_001") }

  let(:input) do
    {
      response_code_pol: "1",
      phone: "",
      additional_value: "0.00",
      test: "1",
      transaction_date: "2019-07-30 11:01:20",
      cc_number: "************3366",
      cc_holder: "APPROVED",
      error_code_bank: "",
      billing_country: "CO",
      bank_referenced_name: "",
      description: "Saludo Famoso de Sebastian Caicedo",
      administrative_fee_tax: "0.00",
      value: "100000.00",
      administrative_fee: "0.00",
      payment_method_type: "2",
      office_phone: "",
      account_id: "512321",
      email_buyer: "jldiaz16@outlook.com",
      response_message_pol: "APPROVED",
      error_message_bank: "",
      shipping_city: "",
      transaction_id: "6e446ad2-7398-495b-bb79-a1a8124e498c",
      sign: "711daa22904773d4ae967db1eafc92de",
      operation_date: "2019-07-30 11:01:20",
      tax: "0.00",
      transaction_bank_id: "00000000",
      payment_method: "10",
      billing_address: "",
      payment_method_name: "VISA",
      pseCycle: "null",
      pse_bank: "",
      state_pol: "4",
      date: "2019.07.30 11:01:20",
      nickname_buyer: "",
      reference_pol: "846076891",
      currency: "COP",
      risk: "0.0",
      shipping_address: "",
      bank_id: "10",
      payment_request_state: "A",
      customer_number: "",
      administrative_fee_base: "0.00",
      attempts: "1",
      merchant_id: ENV["PAYU_MERCHANTID"],
      exchange_rate: "1.00",
      shipping_country: "CO",
      installments_number: "1",
      franchise: "VISA",
      payment_method_id: "2",
      extra1: "",
      extra2: "",
      antifraudMerchantId: "",
      extra3: "",
      commision_pol_currency: "",
      nickname_seller: "",
      ip: "172.18.49.47",
      commision_pol: "0.00",
      airline_code: "",
      billing_city: "",
      pse_reference1: "",
      cus: "00000000",
      reference_sale: "fgreet_001",
      authorization_code: "00000000",
      pse_reference3: "",
      pse_reference2: ""
    }
  end

  context "The input is valid" do
    it "Should create a new payment" do
      expect(result).to be_success

      message_request.reload
      payment = Payment.last

      expect(Payment.count).to eq(1)
      expect(payment.cc_holder).to eq input[:cc_holder]
      expect(payment.value).to eq(100_000)
      expect(payment.currency).to eq("COP")
      expect(payment.payment_method_name).to eq("VISA")
      expect(payment.email_buyer).to eq input[:email_buyer]
      expect(payment.response_code).to eq("APPROVED")
      expect(payment.message_request).to eq(message_request)
      expect(payment.response.symbolize_keys).to eq(input)

      expect(message_request.current_state).to eq("purchased")
      expect(message_request.status).to eq("purchased")
    end
  end

  context "The payment was delicned" do
    it "Should create a new payment but not make the transition" do
      input[:response_message_pol] = "INSUFFICIENT_FUNDS"
      expect(result).to be_success

      message_request.reload
      payment = Payment.last

      expect(Payment.count).to eq(1)
      expect(payment.cc_holder).to eq input[:cc_holder]
      expect(payment.value).to eq(100_000)
      expect(payment.currency).to eq("COP")
      expect(payment.payment_method_name).to eq("VISA")
      expect(payment.email_buyer).to eq input[:email_buyer]
      expect(payment.response_code).to eq("INSUFFICIENT_FUNDS")
      expect(payment.message_request).to eq(message_request)
      expect(payment.response.symbolize_keys).to eq(input)

      expect(message_request.current_state).to eq("pending")
      expect(message_request.current_state).to eq("pending")
    end
  end

  context "The merchant_id is not valid" do
    it "Should create a new payment" do
      input[:merchant_id] = "maliciousd"
      expect(result).to be_failure
      expect(result.failure).to eq(:invalid_merchant_id)

      message_request.reload
      expect(Payment.count).to eq(0)
      expect(message_request.current_state).to eq("pending")
      expect(message_request.status).to eq("pending")
    end
  end

  context "The message_request does not exist" do
    it "Should create a new payment" do
      input[:reference_sale] = "fgreet_00A"
      expect(result).to be_failure
      expect(result.failure).to eq(:mr_not_found)

      message_request.reload
      expect(Payment.count).to eq(0)
      expect(message_request.current_state).to eq("pending")
      expect(message_request.status).to eq("pending")
    end
  end
end
