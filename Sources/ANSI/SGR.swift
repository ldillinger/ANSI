import Foundation

public enum SGR: ANSICodable {
    
    public enum Color: UInt {
        case black =    30
        case red =      31
        case green =    32
        case yellow =   33
        case blue =     34
        case magenta =  35
        case cyan =     36
        case white =    37
        case reset =    39
    }
    
    public enum Style: UInt {
        
        case bold = 1
        case dim = 2
        case italic = 3
        case underlined = 4
        case blink = 5
        case reverse = 7
        case hidden = 8
        case strikethru = 9
        
        var resetValue: UInt { return rawValue + 20 }
    }
    
    case resetAll
    case style(Style)
    case color(Color)
    case bgcolor(Color)
    
    indirect case reset(SGR)
    
    // Internal
    indirect case multi([SGR])
    
    public var ansiValues: [UInt] {
        switch self {
        case .resetAll:         return [0]
        case let .style(s):     return [s.rawValue]
        case let .color(c):     return [c.rawValue]
        case let .bgcolor(c):   return [c.rawValue + 10]
        case let .reset(sgr):   return sgr.resetValues
        case let .multi(cs):    return cs.flatMap { $0.ansiValues }
        }
    }
    
    public var resetValues: [UInt] {
        switch self {
        case .resetAll:          return [0]
        case let .style(s):     return [s.resetValue]
        case .color:            return [Color.reset.rawValue]
        case .bgcolor:          return [Color.reset.rawValue + 10]
        case let .reset(sgr):   return sgr.resetValues
        case let .multi(cs):    return cs.flatMap { $0.resetValues }
        }
    }
    
    public var ansiTerminator: Character { return "m" }
    
    public func compile() -> String { return defaultCompile() }
    
    public func append(_ sgr: SGR) -> SGR {
        let lhsgrs: [SGR]
        let rhsgrs: [SGR]
        switch self {
        case let .multi(sgrs):  lhsgrs = sgrs
        default:                lhsgrs = [self]
        }
        switch sgr {
        case let .multi(sgrs):  rhsgrs = sgrs
        default:                rhsgrs = [sgr]
        }
        return .multi(lhsgrs + rhsgrs)
    }
}
