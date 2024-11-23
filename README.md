# Paypack iOS

Paypack is a cloud service that offers a solution to merchants in need of a resilient, robust and efficient payment service.

Easily request and send funds. Funds are seamlessly delivered to their recipients via mobile money.

Paypack-ios is a wrapper around the Paypack HTTP based API that can be easily integrated with any iOS project.

## Getting started guide

Before any integrations a Paypack account is mandatory, head over to [Paypack](https://payments.paypack.rw) and register for an account.

## Development

Minimum requirement:
- Swift 5.6 or later
- iOS 13.0 or later
- macOS 11 or later

## Installation

### Swift Package Manager

- Paypack-ios support SwiftPM. To use SwiftPM, you should use Xcode 11 or later to open your project.
- Click File -> Swift Packages -> Add Package Dependency
- In the search box, enter https://github.com/nshutinicolas/paypack-ios.git

## Usage

Before you start to use this package, you need to have a `client_id` and `client_secret` you obtain after signing up on [Paypack](https://payments.paypack.rw).

To use the package, import Packpack at the top of your file

```swift
import Paypack
```

Initialize package
```swift
let configs = Configs(clientId: "client_id", clientSecret: "client_secret")
let paypack = Paypack(configs: config, environment: .dev)
```
> Note: By default, the environment is `development`, you may change to `production` depending on your env.

### CashIn Request

> There are 2 methods, synchronous and asynchronous. [Documentation](https://docs.paypack.rw/quickstart/api-reference)

asynchronous usage
```swift
let payload = TransactionPayload(amount: 100, phoneNumber: "0780000000")
let response = try await paypack.cashInRequest(payload)
```

synchronous usage - with completion handler
```swift
let payload = TransactionPayload(amount: 100, phoneNumber: "0780000000")
paypack.cashInRequest(payload) { result in
	switch result {
	case .success(let successResult):
		switch successResult {
		case .success(let successResponse):
			// handle success response
		case .failure(let failureResponse)
			// handle failure response
		}
	case .failure(let failureResult):
		// Handle Error response
	}
}
```

**Cashin request Responses**
 - Success: `SuccessfulRequestResponse`
 - Failure: `FailureRequestResponse`

### CashOut Request
> There are 2 methods, synchronous and asynchronous. [Documentation](https://docs.paypack.rw/quickstart/api-reference)

asynchronous usage
```swift
let payload = TransactionPayload(amount: 100, phoneNumber: "0780000000")
let response = try await paypack.cashOutRequest(payload)
```

synchronous usage - with completion handler
```swift
let payload = TransactionPayload(amount: 100, phoneNumber: "0780000000")
paypack.cashOutRequest(payload) { result in
	switch result {
	case .success(let successResult):
		switch successResult {
		case .success(let successResponse):
			// handle success response
		case .failure(let failureResponse)
			// handle failure response
		}
	case .failure(let failureResult):
		// Handle Error response
	}
}
```

**Cashout request Responses**
 - Success: `SuccessfulRequestResponse`
 - Failure: `FailureRequestResponse`

### Finding a transaction

> There are 2 methods, synchronous and asynchronous. [Documentation](https://docs.paypack.rw/quickstart/api-reference)

asynchronous usage
```swift
let response = try await paypack.transaction(for: "transaction_id")
```

synchronous usage
```swift
paypack.transaction(for: "transaction_id") { result in
	switch result {
	case .success(let successResult):
		switch successResult {
		case .success(let successResponse):
			// handle success response
		case .failure(let failureResponse)
			// handle failure response
		}
	case .failure(let failureResult):
		// Handle Error response
	}
}
```

**Transaction Responses**
 - Success: `SuccessfulTransactionResponse`
 - Failure: `FailureTransactionResponse`

## Support

You can open an issue through [GitHub](https://github.com/nshutinicolas/paypack-ios/issues), [Paypack support](https://community.paypack.rw/) or reachout to [Me](mailto:nshuti.nicolas@yahoo.com)

### License

Released under the [MIT license](./LICENSE).
