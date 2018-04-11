import Foundation

/**
 * Util class to check parameters compliance against regular expression.
 */
public class SanityCheck {
    
    /**
     * Filter items that match the regular expression.
     *
     * @return all items that fail the check
     */
    public func check(items: [SanityItem]) -> [SanityItem] {
        return items.filter { it in
            let regex = try! NSRegularExpression(pattern: it.regExp, options: [])
            
            let matches = regex.matches(in: it.value, options: [], range: NSRange(location: 0, length: it.value.count))
            
            return matches.count == 0
        }
    }
    
    /**
     * Check item compliance and throw exception in case of check fail
     */
    public func checkThrowException(items: [SanityItem]) throws {
        if (!check(items: items).isEmpty) { throw SanityCheckError.SanityCheckFailed(item: items[0]) }
    }
}

/**
 * Exception throw in case of check fail.
 */
public enum SanityCheckError: Error {
    case SanityCheckFailed(item: SanityItem)
}

/**
 * Sanity Item containing the parameter name to check, the value of the parameter and the
 * regular expression to check for.
 */
public struct SanityItem {
    var field: String
    var value: String
    var regExp: String
    
}

extension SanityItem: Equatable {}
public func ==(lhs: SanityItem, rhs: SanityItem) -> Bool {
    return lhs.field == rhs.field &&
        lhs.value == rhs.value &&
        lhs.regExp == rhs.regExp
}
