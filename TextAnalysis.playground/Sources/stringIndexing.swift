import Foundation

// Extend StringProtocol with functions for finding start index, end index and start indices for
// a substring within a string. These are useful extensions for my playground
public extension StringProtocol {
    
    /**
            Returns the starting index of the first occurence of a substring within a string
            - Parameters:
                - string: substring to search for in string
                - options: String comparison operations like `caseInsensitive` or  `literal`
            - Returns: `String.Index` object which is lowerbound of substring's `Range` in string
     */
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    
    /**
           Returns the ending index of the first occurence of a substring within a string
           - Parameters:
               - string: substring to search for in string
               - options: String comparison operations like `caseInsensitive` or  `literal`
           - Returns: `String.Index` object which is upperbound of substring's `Range` in string
    */
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    
    /**
           Returns the starting indices of all occurences of a substring within a string
            - Parameters:
               - string: substring to search for in string
               - options: String comparison options like `caseInsensitive` or  `literal`
            - Returns: array of `String.Index` objects
    */
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    
    /**
           Returns the range of indices of all occurences of a substring within a string
           - Parameters:
               - string: substring to search for in string
               - options: String comparison options like `caseInsensitive` or  `literal
            
           - Returns: `Range` object containing all starting indices of substring within string
    */
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
