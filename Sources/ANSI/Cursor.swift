import Foundation


// NOTE: Cannot multi w/ ansiTerminator because:
//  Cursor is a subset of CSI commands
//  SGR is specific CSI command
//  SGR has special recognition of multiple items
public enum Cursor: ANSICodable {
    
    // https://en.wikipedia.org/wiki/ANSI_escape_code
    
    public enum ClearMode: UInt {
        case pre = 0
        case post = 1
        case all = 2
    }
    
    case up(UInt)
    case down(UInt)
    case forward(UInt)
    case back(UInt)
    
    /*
     // NOTE: NOT ANSI.SYS
     case nextLine(UInt)
     case prevLine(UInt)
     case column(UInt)
     */
    
    case position(UInt,UInt)
    
    case escreen(ClearMode)
    case eline(ClearMode)
    
    /*
     // NOTE: NOT ANSI.SYS
     case scrollUp(UInt)
     case scrollDown(UInt)
     */
    
    case save
    case restore
    
    // Internal
    //indirect case multi([Cursor])
    
    // Synonyms
    public static func right(_ value: UInt) -> Cursor { return .forward(value) }
    public static func left(_ value: UInt) -> Cursor { return .back(value) }
    
    public var ansiValues: [UInt] {
        switch self {
        case let .up(n):            return [n]
        case let .down(n):          return [n]
        case let .forward(n):       return [n]
        case let .back(n):          return [n]
        case let .position(n,m):    return [m + 1, n + 1]   // NOTE: x,y -> line,col transform
        case let .escreen(n):       return [n.rawValue]
        case let .eline(n):         return [n.rawValue]
        case .save:                 return []
        case .restore:              return []
        //case let .multi(ns):        return ns.flatMap { $0.ansiValues }
        }
    }
    
    public var ansiTerminator: Character {
        switch self {
        case .up:       return "A"
        case .down:     return "B"
        case .forward:  return "C"
        case .back:     return "D"
            /*
             case .nextLine: return "E"
             case .prevLine: return "F"
             case .column:   return "G"
             */
        case .position: return "H"
        case .escreen:  return "J"
        case .eline:    return "K"
            /*
             case .scrollUp:     return "S"
             case .scrollDown:   return "T"
             */
        case .save:     return "s"
        case .restore:  return "u"
        //case .multi:    return ""
        }
    }
    
    public func compile() -> String {
        switch self {
        case .escreen:
            // Always position at 0,0
            return defaultCompile() + Cursor.position(0,0).compile()
        default:
            return defaultCompile()
        }
    }
}
