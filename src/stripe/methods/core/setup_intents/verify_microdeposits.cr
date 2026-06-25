class Stripe::SetupIntent
  # Verify a us_bank_account SetupIntent via microdeposits.
  # Provide EITHER `amounts` (two integer cent values) OR a `descriptor_code`.
  def self.verify_microdeposits(
    intent : String | SetupIntent,
    amounts : Array(Int32)? = nil,
    descriptor_code : String? = nil
  ) : SetupIntent
    intent = intent.as(SetupIntent).id if intent.is_a?(SetupIntent)

    io = IO::Memory.new
    builder = ParamsBuilder.new(io)

    {% for x in %w(amounts descriptor_code) %}
      builder.add({{x}}, {{x.id}}) unless {{x.id}}.nil?
    {% end %}

    response = Stripe.client.post("/v1/setup_intents/#{intent}/verify_microdeposits", form: io.to_s)

    if response.status_code == 200
      SetupIntent.from_json(response.body)
    else
      raise Error.from_json(response.body, "error")
    end
  end
end
