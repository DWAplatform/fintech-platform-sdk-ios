//
//  UserProfile.swift
//  FintechPlatform
//
//  Created by ingrid on 11/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation
public struct UserProfile {
    var userid: String
    var name: String?
    var surname: String?
    var nationality: String?
    var dateOfBirth: String?
    var addressOfResidence: String?
    var postalCode: String?
    var cityOfResidence: String?
    var telephone: String?
    var email: String?
    var photo: String?
    var countryOfResidence: String?
    var occupation: String?
    var income: String?
    
    init(userid: String,
         name: String? = nil,
         surname: String? = nil,
         nationality: String? = nil,
         dateOfBirth: String? = nil,
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
        self.dateOfBirth = dateOfBirth
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
