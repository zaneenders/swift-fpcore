import RegexBuilder

public func tokens(_ string: String) throws -> [Token] {

    var tokens: [Token] = []
    var index = 0

    while index < string.count {
        let s = Token.next(string, index)
        if let (t, i) = Token.parseWhiteSpace(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = Token.parseLeftParen(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = Token.parseRightParen(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = Token.parseColen(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = Token.parseFPCore(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = Token.parseString(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = Token.parseRational(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = Token.parseDecl(s) {
            tokens.append(Token(index, t))
            index += i
        } else if let (t, i) = Token.parseSymbol(s) {
            tokens.append(Token(index, t))
            index += i
        } else {
            throw
                LexingError
                .couldNotConsume("\(index) : \(string.count)")
        }
    }
    return tokens
}
