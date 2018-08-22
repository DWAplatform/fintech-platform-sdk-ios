//
//  FintechPlatformAPI.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

/**
 * Fintech Platform Main API Class.
 * Obtain all Fintech Platform objects using this class.
 *
 */
public class FintechPlatformAPI {
    public static let sharedInstance = FintechPlatformAPI()
    
    private init() {}
    
    public func getCashInAPI(hostName: String) -> CashInAPI {
        return CashInAPI(hostName: hostName)
    }
    
    public func getCashOutAPI(hostName: String) -> CashOutAPI {
        return CashOutAPI(hostName: hostName)
    }
    
    public func getBalanceAPI(hostName: String) -> BalanceAPI {
        return BalanceAPI(hostName: hostName)
    }
    
    public func getTransactionsAPI(hostName: String) -> TransactionsAPI {
        return TransactionsAPI(hostName: hostName)
    }
    
    public func getBankAccountAPI(hostName: String) -> BankAccountAPI {
        return BankAccountAPI(hostName: hostName)
    }
    
    public func getPaymentCardAPI(hostName: String, isSanbox: Bool) -> PaymentCardAPI {
        return PaymentCardAPI(hostName: hostName, isSandbox: isSanbox)
    }
    
    public func getProfileAPI(hostName: String) -> ProfileAPI {
        return ProfileAPI(hostName: hostName)
    }
    
    public func getTransferAPI(hostName: String) -> TransferAPI {
        return TransferAPI(hostName: hostName)
    }
    
    public func getKycAPI(hostName: String) -> KycAPI {
        return KycAPI(hostName: hostName)
    }
}
