public struct FPCore: Sendable {
    public var symbol: String? = nil
    public var arguments: [Argument] = []
    public var properties: Properties = Properties()
    public var expr: Expr

    internal init(_ expr: Expr) {
        self.expr = expr
    }

    public init(_ fpCore: String) throws {
        let tokens = try tokens(fpCore)
        guard let fp = parse(tokens) else {
            throw ParserError.parsingFailed
        }
        self = fp
    }
}

extension FPCore: Equatable {
    public static func == (lhs: FPCore, rhs: FPCore) -> Bool {
        guard lhs.symbol == rhs.symbol else {
            return false
        }
        guard lhs.arguments == rhs.arguments else {
            return false
        }
        guard lhs.properties == rhs.properties else {
            return false
        }
        guard lhs.expr == rhs.expr else {
            return false
        }
        return true
    }
}
