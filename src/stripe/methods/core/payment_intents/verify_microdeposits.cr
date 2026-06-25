class Stripe::PaymentIntent
  # Verify a us_bank_account PaymentIntent via microdeposits.
  # Provide EITHER `amounts` (two integer cent values) OR a `descriptor_code`.
  def self.verify_microdeposits(
    intent : String | PaymentIntent,
    amounts : Array(Int32)? = nil,
    descriptor_code : String? = nil
  ) : PaymentIntent
    intent = intent.as(PaymentIntent).id if intent.is_a?(PaymentIntent)

    io = IO::Memory.new
    builder = ParamsBuilder.new(io)

    {% for x in %w(amounts descriptor_code) %}
      builder.add({{x}}, {{x.id}}) unless {{x.id}}.nil?
    {% end %}

    response = Stripe.client.post("/v1/payment_intents/#{intent}/verify_microdeposits", form: io.to_s)

    if response.status_code == 200
      PaymentIntent.from_json(response.body)
    else
      raise Error.from_json(response.body, "error")
    end
  end
end
