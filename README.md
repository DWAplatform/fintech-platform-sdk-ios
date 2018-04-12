Fintech Platform iOS SDK
=================================================
Fintech Platform is an iOS client library to work with Fintech Platform.

Installation
-------------------------------------------------
We recommend that you install the Fintech Platform iOS SDK using Cocoapods.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate DWAplatform into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'FintechPlatform', '~> 1.0.0'
```

Then, run the following command:

```bash
$ pod install
```



License
-------------------------------------------------
Fintech Platform SDK is distributed under MIT license, see LICENSE file.


Contacts
-------------------------------------------------
Report bugs or suggest features using
[issue tracker at GitHub](https://github.com/DWAplatform/dwaplatform-sdk-ios).

Features
-------------------------------------------------
We supply the following modules:

###### FintechPlatformAPI:

1. Cash in 
2. Cash out
3. Balance
4. Payment card registration
5. IBAN address registration
6. Transactions list
7. Peer to peer transfers
8. (profile) User personal informations

Sample usage CashIn API Component in Swift
-------------------------------------------------

Fintech Account (accountId) is credited with 20,00 € using a card (cardId) owned by the user (userId)
``` swift

    // ....

    //  Server host parameters
    let hostName = "FINTECH_PLATFORM_[SANDBOX]_URL"
    let accessToken = "XXXXXXYYYYYY.....ZZZZZZ"
    
    
    //  Set User Account Linked Card parameters
    let tenantId = "87e4ff86-18b6-44cf-87af-af2411ab68c5"
    let userId = "08ad02e8-89fb-44b8-ab65-87eea175adc2"
    let accountId = "f0c84dbc-5d1d-4973-b212-1ac2cd34e5c3"
    let cardId = "2bde23fc-df93-4ff2-acce-51f42be62062"
    
    //  Amount to cashIn
    let amountToCashIn = Money(value: 2000) // amount in euro cent
    
    //  Optional Idempotency
    let idempotencyKey = "idemp1"
    
    //  create cash in API using FintechPlatformAPI instance.
    let fintechPlatform = FintechPlatformAPI.sharedInstance
    let cashInAPI = fintechPlatform.getCashInAPI(hostName: hostName)

    //  Start Cash in
    cashInAPI.cashIn(token: accessToken,
	                userId: userId,
	                accountId: accountId,
	                accountType: "PERSONAL",
	                tenantId: tenantId,
	                cardId: cardId,
	                amount: amountToCashIn,
	                idempotency: idempotencyKey) { optcashinresponse, opterror ->

        if let error = opterror {
            completion(nil, handleErrors(error: error))
            return
        }

        guard let cashInResponse = optcashinresponse else {
            completion(nil, nil)
            return
        }
    
        if (cashInResponse.securecodeneeded) {
            // 3d secure required
            self.view.goToSecure3D(redirecturl: cashInResponse.redirecturl ?? "")
        } else {
            // Cash in completed
        }
    }

```

