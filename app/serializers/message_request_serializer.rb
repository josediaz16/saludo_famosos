class MessageRequestSerializer
  include FastJsonapi::ObjectSerializer
  attributes :brief, :from, :to, :phone_to, :recipient_type

  attribute :solucionis_notitia do |object|
    Payments::GetPaymentData.(object)
  end

  belongs_to :celebrity
  belongs_to :fan, if: Proc.new { |r| r.fan.present? }
end
