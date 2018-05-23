//
//  Money.swift
//  FintechPlatform
//
//  Created by ingrid on 10/04/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public class Money {
    
    private let value: Int64;
    private let currency: Currency?
    
    public init(value: Int64, currency: Currency? = .EUR) {
        self.value = value
        self.currency = currency
    }
    
    public init(value: Int, currency: Currency? = .EUR) {
        self.value = Int64(value)
        self.currency = currency
    }
    
    public static func verifiedValueOf(money: String) -> Money? {
        let newmoney = money.replacingOccurrences(of: ",", with: ".")
        
        // check number of digits after .
        let optrange = newmoney.range(of: ".")
        guard let range = optrange else {
            let optinteg = Int(newmoney)
            guard let integ = optinteg else { return nil }
            return Money(value: integ * 100)
        }
        
        
        let intIndex: Int = newmoney.distance(from: newmoney.startIndex, to: range.lowerBound)
        let integerIndex = newmoney.index(newmoney.startIndex, offsetBy: intIndex)
        
        let decIndex: Int = newmoney.distance(from: newmoney.startIndex, to: range.upperBound)
        let decimalsIndex = newmoney.index(newmoney.startIndex, offsetBy: decIndex)
        let strinteg = String(newmoney[..<integerIndex])
        let strdecimals = String(newmoney[decimalsIndex...])
        
//        let strinteg = newmoney.substring(to: integerIndex)
//        let strdecimals = newmoney.substring(from: decimalsIndex)
        
        if (strdecimals.count > 2) {
            return nil
        }
        
        let strdecimalssanit = strdecimals.count == 0 ? "0" : strdecimals
        
        let optInteger = Int(strinteg)
        let optDecimal = Int(strdecimalssanit)
        
        guard let decimal = optDecimal else {
            return nil
        }
        
        guard let integer = optInteger else {
            return nil
        }
        
        let adjdecimal = strdecimals.count == 1 ? decimal * 10 : decimal
        
        let iv = Int(integer * 100 + adjdecimal)
        return Money(value: iv)
    }
    
    public static func valueOf(money: String) -> Money {
        return verifiedValueOf(money: money) ?? Money(value: 0)
    }
    
    public func toString() -> String {
        return toString(separator: ",");
    }
    
    public func toString(separator: String) -> String {
        
        var value = self.value
        var sign = ""
        if (value < 0) {
            sign = "- "
            value = -value
        }
        
        if (value < 10) {
            return sign + "0"+separator+"0" + String(value)
        }
        else if (value < 100) {
            return sign + "0" + separator + String(value)
        }
        else {
            let i = Int(value / 100)
            
            var si = ""
            if (i < 1000) {
                si = String(i)
            } else {
                var sb = ""
                let full = String(i)
                
                
                let firstindex = full.index(full.startIndex, offsetBy: full.count - 3)
                let firstp = String(full[..<firstindex]) // substring in swift 4
                
                let secondindex = full.index(full.startIndex, offsetBy: firstp.count)
                let secondp = String(full[secondindex...])
                sb.append(firstp)
                sb.append(".")
                sb.append(secondp)
                
                si = sb
            }
            
            let f = Int(value % 100);
            
            var sf = String(f)
            if (f < 10) {
                sf = "0" + sf
            }
            
            let res = sign + si + separator + sf
            return res
        }
    }
    
    public func getValue() -> Int {
        return Int(value);
    }
    
    public func getLongvalue() -> Int64 {
        return value;
    }
    
    public func getCurrency() -> Currency {
        return currency!
    }
}

public enum Currency: String {
    case EUR
    case USD
    case GBP
    case SEK
    case NOK
    case DKK
    case CHF
    case PLN
    case CAD
    case AUD
}
