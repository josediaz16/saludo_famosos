module Payments
  GetSignature = -> price, reference_code do
    Digest::MD5.hexdigest([
      ENV["PAYU_APIKEY"],
      ENV["PAYU_MERCHANTID"],
      reference_code,
      price,
      "COP"
    ].join("~"))
  end
end
