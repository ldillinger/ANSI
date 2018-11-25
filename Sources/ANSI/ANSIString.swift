import Foundation


public struct ANSIString {
    
    public var rawString: String
    public var ansiCodes: [(Int,[ANSICodable])]
    
    public var rawCount: Int { return rawString.count }
    
    public var ansiEncodedString: String {
        var str = ""
        var last = rawString.startIndex
        for (i, codes) in ansiCodes {
            let ii = rawString.index(rawString.startIndex, offsetBy: i)
            str += rawString[last..<ii]
            str += codes.flatMap { $0.compile() }
            last = ii
        }
        return str + rawString[last..<rawString.endIndex]
    }
    
    public init(_ rawString: String = "", ansiCodes: [(Int,[ANSICodable])] = []) {
        self.rawString = rawString
        self.ansiCodes = ansiCodes.sorted { $0.0 < $1.0 }
    }
    
    public init(escaping rawString: String, sgr: SGR) {
        self.rawString = rawString
        self.ansiCodes = [(0, [sgr]), (rawString.count, [SGR.reset(sgr)])]
    }
    
    public func append(_ string: ANSIString) -> ANSIString {
        let combo = rawString + string.rawString
        let codes = ansiCodes + string.ansiCodes.map { ($0.0 + self.rawCount, $0.1) }
        return ANSIString(combo, ansiCodes: codes)
    }
    
    public func append(string: String) -> ANSIString {
        return append(ANSIString(string))
    }
    
}
