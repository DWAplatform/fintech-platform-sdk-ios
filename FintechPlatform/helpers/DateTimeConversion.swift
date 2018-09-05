//
//  DateTimeConversion.swift
//  FintechPlatform
//
//  Created by Tiziano Cappellari on 05/05/2018.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public class DateTimeConversion {
    private static let format = "yyyy-MM-dd'T'HH:mm:ssXXX"
    
    public static func convertFromRFC3339ToDate(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: str)
    }
    
    public static func convert2RFC3339(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
