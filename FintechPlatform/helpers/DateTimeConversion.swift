//
//  DateTimeConversion.swift
//  FintechPlatform
//
//  Created by Tiziano Cappellari on 05/05/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

class DateTimeConversion {
    private let format = "yyyy-MM-dd'T'HH:mm:ssXXX"
    
    func convertFromRFC3339ToDate(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: str)
    }
    
    
}
