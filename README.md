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
pod 'FintechPlatform', '~> 1.3.7'
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

1. Pay in 
2. Cash out
3. Balance
4. Payment card registration
5. IBAN address registration
6. Transactions list
7. Peer to peer transfers
8. Personal user informations
9. Enterprise detailed informations

Sample usage PayIn API Component in Swift
-------------------------------------------------

Fintech Account (accountId) is credited with 20,00 € using a card (cardId) owned by the user (userId)
``` swift
    
    import FintechPlatform
    
    // ....

    //  Server host parameters
    let hostName = "FINTECH_PLATFORM_[SANDBOX]_URL"
    let accessToken = "XXXXXXYYYYYY.....ZZZZZZ"
    
    
    //  Set User Account Linked Card parameters
    let account = Account.personalAccount(user: User(
                userId: UUID(uuidString: "08ad02e8-89fb-44b8-ab65-87eea175adc2")!, 
                tenantId: UUID(uuidString: "87e4ff86-18b6-44cf-87af-af2411ab68c5")!
                ), 
                accountId: UUID(uuidString: "f0c84dbc-5d1d-4973-b212-1ac2cd34e5c3")!
        )

    let cardId = "2bde23fc-df93-4ff2-acce-51f42be62062"
    
    //  Amount to payIn
    let amountToPayIn = Money(value: 2000) // amount in euro cent
    
    //  Optional Idempotency
    let idempotencyKey = "idemp1"
    
    //  create pay in API using FintechPlatformAPI instance.
    let fintechPlatform = FintechPlatformAPI.sharedInstance
    let payInAPI = fintechPlatform.getPayInAPI(hostName: hostName)

    //  Start Pay in
    payInAPI.payIn(token: accessToken,
	                account: account,
	                cardId: cardId,
	                amount: amountToPayIn,
	                idempotency: idempotencyKey) { optcpayinresponse, opterror in
        DispatchQueue.main.async {
            if let error = opterror {
                completion(nil, handleErrors(error: error))
                return
            }

            guard let payInResponse = optpayinresponse else {
                completion(nil, nil)
                return
            }
        
            if (payInResponse.securecodeneeded) {
                // 3d secure required
                self.view.goToSecure3D(redirecturl: payInResponse.redirecturl ?? "")
            } else {
                // Pay in completed
            }

        }
    }

```

