import Foundation

// ANSICodable Operators

public func + <T: ANSICodable, U: ANSICodable> (_ lhs: T, rhs: U) -> ANSIString {
    return ANSIString("", ansiCodes: [(0, [lhs,rhs])])
}

public func + <T: ANSICodable> (_ lhs: T, rhs: String) -> ANSIString {
    return lhs.ansiString.append(string: rhs)
}

public func + <T: ANSICodable> (_ lhs: String, rhs: T) -> ANSIString {
    return ANSIString(lhs).append(rhs.ansiString)
}

//infix operator +> : AdditionPrecedence

// ANSIString Operators

public func + <T: ANSICodable> (_ lhs: ANSIString, rhs: T) -> ANSIString {
    return lhs.append(rhs.ansiString)
}

public func + (_ lhs: ANSIString, rhs: ANSIString) -> ANSIString {
    return lhs.append(rhs)
}

public func + (_ lhs: ANSIString, rhs: String) -> ANSIString {
    return lhs.append(string: rhs)
}

// Cursor
//public func & (_ lhs: Cursor, rhs: Cursor) -> Cursor {
//    return lhs.append(rhs)
//}

// SGR Operators
public func & (_ lhs: SGR, rhs: SGR) -> SGR {
    return lhs.append(rhs)
}

