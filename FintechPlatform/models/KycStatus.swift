//
//  KycStatus.swift
//  FintechPlatform
//
//  Created by Matteo Stefanini on 28/08/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public enum KycStatus: String, Codable {
    case VALIDATION_ASKED = "VALIDATION_ASKED"
    case INVALID = "INVALID"
    case VALIDATED = "VALIDATED"
    case CREATED = "CREATED"
}
