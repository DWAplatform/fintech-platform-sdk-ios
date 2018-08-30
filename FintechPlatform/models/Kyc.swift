//
//  Kyc.swift
//  FintechPlatform
//
//  Created by Matteo Stefanini on 29/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public struct Kyc: Codable {    
    var kycId: UUID
    var documentId: UUID
    var status: KycStatus
    var created: Date
    var error: Error
    
    struct Error: Codable {
        var code: String
        var message: String
    }
}
