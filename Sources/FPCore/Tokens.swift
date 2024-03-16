public struct Token {

    public let offest: Int
    public let type: FPCoreToken

    init(_ offest: Int, _ type: FPCoreToken) {
        self.offest = offest
        self.type = type
    }

    public enum FPCoreToken {
        case leftParen
        case fpcore
        case symbol(String)
        case string(String)
        case number(Number)
        case whiteSpace(String)
        case colen
        case rightParen
    }

    public enum Number {
        case rational(String)
        case decieml(String)
    }
}

extension Token {

    static func parseSymbol(_ str: Substring) -> (FPCoreToken, Int)? {
        let r = #/[a-zA-Z~!@$%^&*_\-+=<>.?/:][a-zA-Z0-9~!@$%^&*_\-+=<>.?/:]*/#
        if let match: Regex<Substring>.Match = str.prefixMatch(of: r) {
            return (
                FPCoreToken.symbol(String(match.output)),
                match.output.count
            )
        }
        return nil
    }

    static func parseDecl(_ str: Substring) -> (FPCoreToken, Int)? {
        let r = #/[-+]?([0-9]+(\.[0-9]+)?|\.[0-9]+)(e[-+]?[0-9]+)?/#
        if let match = str.prefixMatch(of: r) {
            return (
                FPCoreToken.number(.decieml((String(match.output.0)))),
                match.output.0.count
            )
        }
        return nil
    }

    static func parseRational(_ str: Substring) -> (FPCoreToken, Int)? {
        let r = #/[+-]?[0-9]+/[0-9]*[1-9][0-9]*/#
        if let match = str.prefixMatch(of: r) {
            return (
                FPCoreToken.number(.rational((String(match.output)))),
                match.output.count
            )
        }
        return nil
    }

    static func parseString(_ str: Substring) -> (FPCoreToken, Int)? {
        let r = #/"([\x20-\x21\x23-\x5b\x5d-\x7e]|\\["\\])*"/#
        if let match = str.prefixMatch(of: r) {
            return (
                FPCoreToken.string(String(match.output.0)),
                match.output.0.count
            )
        }
        return nil
    }

    static func parseColen(_ str: Substring) -> (FPCoreToken, Int)? {
        if let match: Regex<Substring>.Match = str.prefixMatch(of: ":") {
            return (FPCoreToken.colen, match.output.count)
        }
        return nil
    }

    static func parseFPCore(_ str: Substring) -> (FPCoreToken, Int)? {
        if let match: Regex<Substring>.Match = str.prefixMatch(of: "FPCore") {
            return (FPCoreToken.fpcore, match.output.count)
        }
        return nil
    }

    static func parseLeftParen(_ str: Substring) -> (FPCoreToken, Int)? {
        if let match: Regex<Substring>.Match = str.prefixMatch(of: "(") {
            return (FPCoreToken.leftParen, match.output.count)
        }
        return nil
    }

    static func parseRightParen(_ str: Substring) -> (FPCoreToken, Int)? {
        if let match: Regex<Substring>.Match = str.prefixMatch(of: ")") {
            return (FPCoreToken.rightParen, match.output.count)
        }
        return nil
    }

    static func parseWhiteSpace(_ str: Substring) -> (FPCoreToken, Int)? {
        if let match: Regex<Substring>.Match = str.prefixMatch(of: .whitespace)
        {
            return (
                FPCoreToken.whiteSpace(String(match.output)), match.output.count
            )
        }
        return nil
    }

    static func next(_ str: String, _ index: Int) -> Substring {
        str.suffix(from: str.index(str.startIndex, offsetBy: index))
    }
}
