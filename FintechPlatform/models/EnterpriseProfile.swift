//
//  EnterpriseProfile.swift
//  FintechPlatform
//
//  Created by ingrid on 01/10/2019.
//  Copyright © 2019 Fintech Platform. All rights reserved.
//

import Foundation
public struct EnterpriseProfile: Codable {
    public let tenantId: UUID
    public let enterpriseId: UUID
    public let legalRepresentativeId: UUID?
    public let telephone: String?
    public let email: String?
    public let name: String?
    public let enterpriseType: EnterpriseType?
    public let countryHeadquarters: String?
    public let addressOfHeadquarters: String?
    public let postalCodeHeadquarters: String?
    public let businessLogo: UUID?
    //public let created: String
    //public let updated: String
    
    public init(tenantId: UUID,
                enterpriseId: UUID,
                legalRepresentativeId: UUID?=nil,
                telephone: String?=nil,
                email: String?=nil,
                name: String?=nil,
                enterpriseType: EnterpriseType?=nil,
                countryHeadquarters: String?=nil,
                addressOfHeadquarters: String?=nil,
                postalCodeHeadquarters: String?=nil,
                businessLogo: UUID?=nil
                //created: String,
                //updated: String
    ) {
        self.tenantId = tenantId
        self.enterpriseId = enterpriseId
        self.legalRepresentativeId = legalRepresentativeId
        self.telephone = telephone
        self.email = email
        self.name = name
        self.enterpriseType = enterpriseType
        self.countryHeadquarters = countryHeadquarters
        self.addressOfHeadquarters = addressOfHeadquarters
        self.postalCodeHeadquarters = postalCodeHeadquarters
        self.businessLogo = businessLogo
        //self.created = created
        //self.updated = updated
    }
}

public enum EnterpriseType: String, Codable {
    case BUSINESS = "BUSINESS"
    case ORGANIZATION = "ORGANIZATION"
    case SOLETRADER = "SOLETRADER"
}
