//
//  KycRequest.swift
//  FintechPlatform
//
//  Created by Matteo Stefanini on 28/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public struct KycRequested: Codable {
    public var kycId: UUID
    public var documentId: UUID
    public var status: KycStatus
}
