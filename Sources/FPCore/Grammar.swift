public struct Properties: Sendable, Equatable {
    public internal(set) var props: [Symbol: Data] = [:]
}

public enum Data: Sendable, Equatable {
    case symbol(Symbol)
    case string(String)
}

public enum Expr: Sendable, Equatable {
    case symbol(Symbol)
    case number(Number)
    case operation(Operation, [Expr])  // none empty array
}

public enum Number: Sendable, Equatable {
    case rational(String)
    case decnum(String)
    case hexnum(String)
    case digits
}

public enum Operation: Sendable {
    case fabs
    case minus
    case div
    case plus
    case times
}

public struct Symbol: Sendable, Hashable {
    init(_ sym: String) {
        self.sym = sym
    }
    public let sym: String
}

// mabye struct arguments to store parens and white space
public enum Argument: Sendable, Equatable {
    case symbol(Symbol)
    //( symbol dimension+ )
    //( ! property* symbol dimension* )
}
