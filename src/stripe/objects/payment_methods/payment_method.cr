class Stripe::PaymentMethod
  include JSON::Serializable
  include StripeMethods

  add_retrieve_method

  class BillingDetails
    include JSON::Serializable

    getter address : Stripe::Address?
    getter email : String?
    getter name : String?
    getter phone : String?
  end

  # Card details as they appear nested on a PaymentMethod. NOT the legacy
  # PaymentMethods::Card object — that one requires an `id` this sub-block lacks.
  class Card
    include JSON::Serializable

    getter brand : String? # "visa" | "mastercard" | ...
    getter last4 : String?
    getter exp_month : UInt8?
    getter exp_year : UInt16?
    getter fingerprint : String?
  end

  # Modern us_bank_account (ACH direct-debit) PaymentMethod details.
  # NOT the legacy Sources-shaped PaymentMethods::BankAccount object.
  class UsBankAccount
    include JSON::Serializable

    getter account_holder_type : String? # "individual" | "company"
    getter account_type : String?        # "checking" | "savings"
    getter bank_name : String?
    getter fingerprint : String?
    getter last4 : String?
    getter routing_number : String?
  end

  getter id : String

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created : Time
  getter customer : String? | Stripe::Customer?
  getter description : String?
  getter type : String?
  getter? livemode : Bool

  getter billing_details : BillingDetails?

  @[JSON::Field(key: "us_bank_account")]
  getter us_bank_account : UsBankAccount?

  getter card : Card?
end
