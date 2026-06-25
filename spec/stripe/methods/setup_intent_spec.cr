require "../../spec_helper"

describe Stripe::SetupIntent do
  it "create setup intent" do
    WebMock.stub(:post, "https://api.stripe.com/v1/setup_intents")
      .to_return(status: 200, body: File.read("spec/support/create_setup_intent.json"), headers: {"Content-Type" => "application/json"})

    intent = Stripe::SetupIntent.create

    intent.id.should eq("seti_1GSdvVIfhoELGSZwebOwTZO1")
  end

  it "retrieve setup intent" do
    WebMock.stub(:get, "https://api.stripe.com/v1/setup_intents/asddad")
      .to_return(status: 200, body: File.read("spec/support/retrieve_setup_intent.json"), headers: {"Content-Type" => "application/json"})

    intent = Stripe::SetupIntent.retrieve("asddad")
    intent.id.should eq("seti_123456789")
  end

  it "listing setup intent" do
    WebMock.stub(:get, "https://api.stripe.com/v1/setup_intents")
      .to_return(status: 200, body: File.read("spec/support/list_setup_intents.json"), headers: {"Content-Type" => "application/json"})

    intents = Stripe::SetupIntent.list
    intents.first.id.should eq("seti_123456789")
  end

  it "confirm setup intent" do
    WebMock.stub(:post, "https://api.stripe.com/v1/setup_intents/asdad/confirm")
      .to_return(status: 200, body: File.read("spec/support/confirm_setup_intent.json"), headers: {"Content-Type" => "application/json"})

    intent = Stripe::SetupIntent.confirm("asdad", payment_method: "pm_card_visa")
    intent.id.should eq("seti_123456789")
    intent.status.should eq(Stripe::SetupIntent::Status::RequiresPaymentMethod)
  end

  it "creates an ACH (us_bank_account) setup intent" do
    WebMock.stub(:post, "https://api.stripe.com/v1/setup_intents")
      .with(body: "payment_method_types%5B0%5D=us_bank_account&payment_method_options%5Bus_bank_account%5D%5Bverification_method%5D=automatic")
      .to_return(status: 200, body: File.read("spec/support/create_setup_intent.json"), headers: {"Content-Type" => "application/json"})

    intent = Stripe::SetupIntent.create(
      payment_method_types: ["us_bank_account"],
      payment_method_options: {us_bank_account: {verification_method: "automatic"}},
    )

    intent.id.should eq("seti_1GSdvVIfhoELGSZwebOwTZO1")
  end

  it "verifies microdeposits with amounts" do
    WebMock.stub(:post, "https://api.stripe.com/v1/setup_intents/seti_123456789/verify_microdeposits")
      .with(body: "amounts%5B0%5D=32&amounts%5B1%5D=45")
      .to_return(status: 200, body: File.read("spec/support/verify_microdeposits_setup_intent.json"), headers: {"Content-Type" => "application/json"})

    intent = Stripe::SetupIntent.verify_microdeposits("seti_123456789", amounts: [32, 45])
    intent.id.should eq("seti_123456789")
    intent.status.should eq(Stripe::SetupIntent::Status::Succeeded)
  end

  it "verifies microdeposits with a descriptor_code" do
    WebMock.stub(:post, "https://api.stripe.com/v1/setup_intents/seti_123456789/verify_microdeposits")
      .with(body: "descriptor_code=SM11AA")
      .to_return(status: 200, body: File.read("spec/support/verify_microdeposits_setup_intent.json"), headers: {"Content-Type" => "application/json"})

    intent = Stripe::SetupIntent.verify_microdeposits("seti_123456789", descriptor_code: "SM11AA")
    intent.id.should eq("seti_123456789")
  end
end
