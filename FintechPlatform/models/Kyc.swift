//
//  Kyc.swift
//  FintechPlatform
//
//  Created by Matteo Stefanini on 29/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public struct Kyc: Codable {    
    public var kycId: UUID
    public var documentId: UUID
    public var status: KycStatus
    public var created: Date
    public var error: Error?
    
    public struct Error: Codable {
        public var code: String
        public var message: String
    }
}
