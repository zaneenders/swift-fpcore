public func parse(_ tokens: [Token]) -> [FPCore] {
    var consumed = 0
    var cores: [FPCore] = []
    var failed = false
    while consumed < tokens.count {
        if let (c, i) = parseFPCore(0, Array(tokens[consumed..<tokens.count])) {
            consumed += i
            cores.append(c)
        } else {
            if failed {
                return cores
            } else {
                failed = true
            }
        }
    }
    return cores
}

private func parseFPCore(_ index: Int, _ tokens: [Token]) -> (FPCore, Int)? {
    var i = consumeWhiteSpace(index, tokens)
    guard peekLeftParen(i, tokens) && peekFPCore(i + 1, tokens) else {
        return nil
    }
    i += 2
    // TODO check for optional Symbol
    guard let (ai, args) = consumeArguments(i, tokens) else {
        return nil
    }
    i = ai
    let (pi, props) = consumeProperties(i, tokens)
    i = pi
    guard let (ei, expr) = consumeExpr(i, tokens) else {
        return nil
    }
    guard peekRightParen(ei, tokens) else {
        return nil
    }
    var fp = FPCore(expr)
    fp.arguments = args
    fp.properties = props
    return (fp, i)
}

private func consumeExpr(_ index: Int, _ tokens: [Token]) -> (Int, Expr)? {
    var i = consumeWhiteSpace(index, tokens)
    switch tokens[i].type {
    case .number(.decieml(let d)):
        return (i + 1, .number(.decnum(d)))
    case .symbol(let sym):
        return (i + 1, .symbol(Symbol(sym)))
    case .leftParen:
        i = consumeWhiteSpace(i + 1, tokens)
        guard let (oi, op) = consumeOperation(i, tokens) else {
            return nil
        }
        i = consumeWhiteSpace(oi, tokens)
        var exprs: [Expr] = []
        guard let (ei, e) = consumeExpr(i, tokens) else {
            return nil
        }
        exprs.append(e)
        i = ei
        while let (xi, exp) = consumeExpr(i, tokens) {
            i = xi
            exprs.append(exp)
        }
        i = consumeWhiteSpace(i, tokens)
        guard peekRightParen(i, tokens) else {
            return nil
        }
        return (i + 1, .operation(op, exprs))
    default:
        return nil
    }
}

private func consumeOperation(
    _ index: Int, _ tokens: [Token]
) -> (
    Int, Operation
)? {
    switch tokens[index].type {
    case .symbol(let s):
        switch s {
        case "fabs":
            return (index + 1, .fabs)
        case "+":
            return (index + 1, .plus)
        case "-":
            return (index + 1, .minus)
        case "/":
            return (index + 1, .div)
        case "*":
            return (index + 1, .times)
        default:
            return nil
        }
    default:
        return nil
    }
}

private func consumeProperties(
    _ index: Int, _ tokens: [Token]
) -> (
    Int, Properties
) {
    var i = consumeWhiteSpace(index, tokens)
    var props = Properties()
    while let (c, sym, data) = consumeProp(i, tokens) {
        props.props[sym] = data
        i = c
    }
    return (i, props)
}

private func consumeProp(
    _ index: Int, _ tokens: [Token]
) -> (
    Int, Symbol, Data
)? {
    var i = consumeWhiteSpace(index, tokens)
    guard peekColen(i, tokens) else {
        return nil
    }
    guard let (c, sym) = consumeSymbol(i + 1, tokens) else {
        return nil
    }
    i = consumeWhiteSpace(c, tokens)
    guard let (c, data) = consumeData(i, tokens) else {
        return nil
    }
    return (c, sym, data)
}

private func consumeArguments(
    _ index: Int, _ tokens: [Token]
)
    -> (Int, [Argument])?
{
    var i = consumeWhiteSpace(index, tokens)
    guard peekLeftParen(i, tokens) else {
        return nil
    }
    i += 1
    var consumSymbols = true
    var args: [Argument] = []
    while consumSymbols {
        switch tokens[i].type {
        case .symbol(let sym):
            args.append(.symbol(Symbol(sym)))
            i += 1
        case .whiteSpace(_):
            i += 1
        default:
            consumSymbols = false
        }
    }
    i = consumeWhiteSpace(i, tokens)
    guard peekRightParen(i, tokens) else {
        return nil
    }
    return (i + 1, args)
}

private func consumeData(_ index: Int, _ tokens: [Token]) -> (Int, Data)? {
    switch tokens[index].type {
    case .symbol(let sym):
        return (index + 1, .symbol(Symbol(sym)))
    case .string(let str):
        return (index + 1, .string(str))
    default:
        return nil
    }
}

private func consumeSymbol(_ index: Int, _ tokens: [Token]) -> (Int, Symbol)? {
    switch tokens[index].type {
    case .symbol(let sym):
        return (index + 1, Symbol(sym))
    default:
        return nil
    }
}

private func peekColen(_ index: Int, _ tokens: [Token]) -> Bool {
    switch tokens[index].type {
    case .colen:
        return true
    default:
        return false
    }
}
private func peekFPCore(_ index: Int, _ tokens: [Token]) -> Bool {
    switch tokens[index].type {
    case .fpcore:
        return true
    default:
        return false
    }
}

private func peekRightParen(_ index: Int, _ tokens: [Token]) -> Bool {
    switch tokens[index].type {
    case .rightParen:
        return true
    default:
        return false
    }
}

private func peekLeftParen(_ index: Int, _ tokens: [Token]) -> Bool {
    switch tokens[index].type {
    case .leftParen:
        return true
    default:
        return false
    }
}

// returns the index of token after last whitespace
private func consumeWhiteSpace(_ index: Int, _ tokens: [Token]) -> Int {
    var i = index
    var consumeWhiteSpace = true
    while consumeWhiteSpace {
        switch tokens[i].type {
        case .whiteSpace(_):
            i += 1
        case .comment(let c):
            i += 1
        default:
            consumeWhiteSpace = false
        }
    }
    return i
}
