import Foundation
/**
 * Card helper class.
 * Check card data validity and create card number alias.
 */
open class CardHelper {
    
    private let sanityCheck : SanityCheck
    
    public init(sanityCheck: SanityCheck) {
        self.sanityCheck = sanityCheck
    }
    
    public static func generateAlias(cardNumber: String) -> String {
        let indexTo = cardNumber.index(cardNumber.startIndex, offsetBy: 6)
        let indexFrom = cardNumber.index(cardNumber.endIndex, offsetBy: -4)
        return "\(String(cardNumber[..<indexTo]))XXXXXX\(String(cardNumber[indexFrom...]))"
    }
    
    open func checkCardNumberFormat(cardNumber: String) throws {
        try sanityCheck.checkThrowException(items: [SanityItem(field: "cardNumber", value: cardNumber, regExp: "\\d{16}")])
    }
    
    open func checkCardExpirationFormat(expiration: String) throws {
        try sanityCheck.checkThrowException(items: [SanityItem(field: "expiration", value: expiration, regExp: "\\d{4}")])
    }
    
    open func checkCardCXVFormat(cxv: String) throws {
        try sanityCheck.checkThrowException(items: [SanityItem(field: "cxv", value: cxv, regExp: "\\d{3}")])
    }
    
    open func checkCardFormat(cardNumber: String, expiration: String, cxv: String) throws {
        try checkCardNumberFormat(cardNumber: cardNumber)
        try checkCardExpirationFormat(expiration: expiration)
        try checkCardCXVFormat(cxv: cxv)
    }
}
