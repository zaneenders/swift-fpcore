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

func argsString(_ args: [Argument]) -> String {
    var out = "("
    for arg in args {
        switch arg {
        case .symbol(let sym):
            out.append(" \(sym.sym) ")
        }
    }
    out += ")"
    return out
}

extension Properties: CustomStringConvertible {
    public var description: String {
        var out = ""
        for prop in props {
            switch prop.value {
            case .string(let s):
                out.append(":\(prop.key.sym) \(s)")
            case .symbol(let s):
                out.append(":\(prop.key.sym) \(s)")
            }
        }
        return out
    }
}

extension Expr: CustomStringConvertible {
    public var description: String {
        var out = ""
        switch self {
        case .number(let n):
            switch n {
            case .decnum(let d):
                out.append("\(d)")
            case .digits:
                out.append("")
            case .hexnum(let h):
                out.append("\(h)")
            case .rational(let r):
                out.append("\(r)")
            }
        case .symbol(let s):
            out.append("\(s.sym)")
        case .operation(let op, let exprs):
            var exprStr = ""
            for expr in exprs {
                exprStr.append(" \(expr.description) ")
            }
            switch op {
            case .div:
                out.append("(/ \(exprStr) )")
            case .fabs:
                out.append("(fabs \(exprStr) )")
            case .plus:
                out.append("(+ \(exprStr) )")
            case .minus:
                out.append("(- \(exprStr) )")
            case .times:
                out.append("(* \(exprStr) )")
            }
        }
        return out
    }
}

extension FPCore: CustomStringConvertible {
    public var description: String {
        """
        (FPCore \(argsString(self.arguments))
         \(self.properties)
         \(self.expr))
        """
    }
}
