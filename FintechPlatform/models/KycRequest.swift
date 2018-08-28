//
//  KycRequest.swift
//  FintechPlatform
//
//  Created by Matteo Stefanini on 28/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public struct KycRequested: Codable {
    var kycId: UUID
    var documentId: UUID
    var status: KycStatus
}
