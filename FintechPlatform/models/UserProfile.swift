//
//  UserProfile.swift
//  FintechPlatform
//
//  Created by ingrid on 11/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public struct UserProfile {
    public var userid: String
    public var name: String?
    public var surname: String?
    public var nationality: String?
    public var birthday: Date?
    public var addressOfResidence: String?
    public var postalCode: String?
    public var cityOfResidence: String?
    public var telephone: String?
    public var email: String?
    public var photo: String?
    public var countryOfResidence: String?
    public var occupation: String?
    public var income: String?
    
    public init(userid: String,
                 name: String? = nil,
                 surname: String? = nil,
                 nationality: String? = nil,
                 birthday: Date? = nil,
                 addressOfResidence: String? = nil,
                 postalCode: String? = nil,
                 cityOfResidence: String? = nil,
                 telephone: String? = nil,
                 email: String? = nil,
                 photo: String? = nil,
                 countryOfResidence: String? = nil,
                 occupation: String? = nil,
                 income: String? = nil) {
        
        self.userid = userid
        self.name = name
        self.surname = surname
        self.nationality = nationality
        self.birthday = birthday
        self.addressOfResidence = addressOfResidence
        self.postalCode = postalCode
        self.cityOfResidence = cityOfResidence
        self.telephone = telephone
        self.email = email
        self.photo = photo
        self.countryOfResidence = countryOfResidence
        self.occupation = occupation
        self.income = income
    }
}
