import Foundation

// TODO: Monoids
public protocol ANSICodable {
    var ansiValues: [UInt] { get }
    var ansiSeparator: Character { get }
    var ansiTerminator: Character { get }
    func compile() -> String
}

public extension ANSICodable {
    
    public var escapeChar: Character { return "\u{1b}" } // TODO: Move to ANSI (not SGR)
    public var ansiSeparator: Character { return ";" }
    
    public var compiled: String { return compile() }
    
    public func defaultCompile() -> String {
        let inner = ansiValues.map { String($0) }.joined(separator: String(ansiSeparator))
        return "\(escapeChar)[\(inner)\(ansiTerminator)"
    }
    
    public var ansiString: ANSIString {
        return ANSIString("", ansiCodes: [(0, [self])])
    }
    
    public var ansiEncodedString: String {
        return ansiString.ansiEncodedString
    }
    
}
