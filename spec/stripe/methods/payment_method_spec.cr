require "../../spec_helper"

describe Stripe::PaymentMethod do
  it "retrieve payment method" do
    WebMock.stub(:get, "https://api.stripe.com/v1/payment_methods/asddad")
      .to_return(status: 200, body: File.read("spec/support/retrieve_payment_method.json"), headers: {"Content-Type" => "application/json"})

    payment_method = Stripe::PaymentMethod.retrieve("asddad")
    payment_method.id.should eq("pm_1EUnwZ4XsdaddaBS77el70wJ")
  end

  it "attaches payment method" do
    WebMock.stub(:post, "https://api.stripe.com/v1/payment_methods/pm_1EUnwZ4XsdaddaBS77el70wJ/attach")
      .to_return(status: 200, body: File.read("spec/support/attach_payment_method.json"), headers: {"Content-Type" => "application/json"})

    payment_method = Stripe::PaymentMethod.attach("pm_1EUnwZ4XsdaddaBS77el70wJ", "cus_4QHS5k9YC2TcST")
    payment_method.customer.should eq("cus_4QHS5k9YC2TcST")
  end

  it "deserializes a us_bank_account payment method" do
    WebMock.stub(:get, "https://api.stripe.com/v1/payment_methods/pm_1MqLiJLkdIwHu7ixUEgbFdYF")
      .to_return(status: 200, body: File.read("spec/support/retrieve_us_bank_account_payment_method.json"), headers: {"Content-Type" => "application/json"})

    payment_method = Stripe::PaymentMethod.retrieve("pm_1MqLiJLkdIwHu7ixUEgbFdYF")
    payment_method.type.should eq("us_bank_account")
    bank = payment_method.us_bank_account.not_nil!
    bank.bank_name.should eq("STRIPE TEST BANK")
    bank.last4.should eq("6789")
    bank.routing_number.should eq("110000000")
    bank.account_type.should eq("checking")
    bank.account_holder_type.should eq("individual")
  end
end
