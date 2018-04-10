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
    
    public func getCashInAPI(hostName: String) -> CashInApi {
        return CashInApi(hostName: hostName)
    }
}
