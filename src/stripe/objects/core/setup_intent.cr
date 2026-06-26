@[EventPayload]
class Stripe::SetupIntent
  include JSON::Serializable
  include StripeMethods

  add_retrieve_method
  add_list_method(
    customer : String? = nil,
    limit : Int32? = nil,
    starting_after : String? = nil,
    ending_before : String? = nil
  )

  enum Status
    RequiresPaymentMethod
    RequiresConfirmation
    RequiresAction
    Processing
    Canceled
    Succeeded
  end

  # Set while the SetupIntent needs an extra step before it's usable. For ACH the
  # case we care about is manual microdeposit verification, where Stripe exposes a
  # hosted page the customer uses to enter the amounts/descriptor code.
  class NextAction
    include JSON::Serializable

    class VerifyWithMicrodeposits
      include JSON::Serializable

      getter arrival_date : Int64?
      getter hosted_verification_url : String?
      getter microdeposit_type : String?
    end

    getter type : String?
    getter verify_with_microdeposits : VerifyWithMicrodeposits?
  end

  getter id : String
  getter application : String?
  getter cancellation_reason : String?
  getter client_secret : String?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created : Time
  getter customer : String? | Stripe::Customer?
  getter client_secret : String?
  getter description : String?
  getter? livemode : Bool
  getter last_setup_error : Hash(String, String | PaymentMethods::Card | PaymentMethods::BankAccount)?
  getter metadata : Hash(String, String)?
  getter payment_method_types : Array(String | Stripe::PaymentMethod)
  getter payment_method : String? | Stripe::PaymentMethod?

  @[JSON::Field(converter: Enum::StringConverter(Stripe::SetupIntent::Status))]
  getter status : Status
  getter usage : String
  getter next_action : NextAction?

  # Stripe-hosted page where the customer enters microdeposit amounts / the
  # descriptor code to verify an ACH bank account. Present only while the
  # SetupIntent is awaiting manual microdeposit verification; nil otherwise
  # (cards, instant-verified ACH, or still-processing instant verification).
  def verify_with_microdeposits_url : String?
    self.next_action.try(&.verify_with_microdeposits).try(&.hosted_verification_url)
  end
end
