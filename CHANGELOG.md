# Changelog

## v1.1

- Supporting Crystal 0.35.1
- Added support for [Stripe Checkout](https://stripe.com/payments/checkout) (#7)
- Added support for [Invoice Line Item Creation](https://stripe.com/docs/api/invoiceitems/create) (#5)

## v1.0

- Added this changelog file
- Supporting Crystal 0.34
- Moving all structs to classes to fix compiler issues
- Changed structure of the calls, using class methods and class variables for api key. Will use less memory and be much cleaner.
- Added expand to these entities create methods: Customer, Charge, SetupIntent, PaymentIntent, and Token
- Made List Enumerable - So all Enumerable's methods works on lists

### Added api calls

- Create source
- Retrieve source
- Attach source to customer
- Detach source from customer
- Add tax id to a customer
- Remove tax id from customer
- Retrieve tax id from customer
- Retrieve charge
- create refund
- retrieve refund
- list customers
- list subscriptions
- list invoices
- list payment intents
- list setup intents
- create tax rate
- retrieve tax rate

### Added Entities

- Coupons
- Customer Tax ID
- Payout
- Source

## v0.2 (2020-03-31)

- Added some core entities
- Fixed bug in Charges
- Removed validations macro
- Added support for sending post params with array and array with Hashes/NamedTuples
- Added expand only on `create_subscription` method

### Added api calls

- payment/setup intent create
- payment/setup intent retrieve
- payment/setup intent confirm
- create product
- create plan

### Added Entities

- Payment Intent
- Setup Intent
- Plan
- Product
