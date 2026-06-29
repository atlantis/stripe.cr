class Stripe::PaymentIntent
  def self.confirm(
    intent : String | PaymentIntent? = nil,
    payment_method : String | Token | PaymentMethods::Card | PaymentMethods::BankAccount? = nil,
    receipt_email : String? = nil,
    return_url : String? = nil,
    idempotency_key : String? = nil
  ) : PaymentIntent forall T, U
    intent = intent.as(PaymentIntent).id if intent.is_a?(PaymentIntent)

    if payment_method.is_a?(Token | PaymentMethods::Card | PaymentMethods::BankAccount)
      payment_method = payment_method.id
    end

    io = IO::Memory.new
    builder = ParamsBuilder.new(io)

    {% for x in %w(payment_method receipt_email return_url) %}
      builder.add({{x}}, {{x.id}}) unless {{x.id}}.nil?
    {% end %}

    headers = HTTP::Headers.new
    headers["Idempotency-Key"] = idempotency_key if idempotency_key

    response = Stripe.client.post("/v1/payment_intents/#{intent}/confirm", headers: headers, form: io.to_s)

    if response.status_code == 200
      PaymentIntent.from_json(response.body)
    else
      raise Error.from_json(response.body, "error")
    end
  end
end
