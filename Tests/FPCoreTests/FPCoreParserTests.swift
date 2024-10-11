import RegexBuilder
import XCTest

@testable import FPCore

final class FPCoreParserTests: XCTestCase {

    func testFile() throws {
        let file = """
            ; -*- mode: scheme -*-

            (FPCore (x)
            :name "Cancel like terms"
            (- (+ 1 x) x))

            (FPCore (x)
            :name "Expanding a square"
            (- (* (+ x 1) (+ x 1)) 1))

            (FPCore (x y z)
            :name "Commute and associate"
            (- (+ (+ x y) z) (+ x (+ y z))))
            """
        let tokens = try tokens(file)
        let fpcores = parse(tokens)
        let b = """
            (FPCore (x)
            :name "Cancel like terms"
            (- (+ 1 x) x))
            """
        assertDirtyEqualFPCOre(fpcores.first!.description, b)
        XCTAssertEqual(fpcores.count, 3)
    }

    func assertDirtyEqualFPCOre(_ left: String, _ right: String) {
        let a = left.replacing(with: "", maxReplacements: Int.max) {
            Regex {
                ZeroOrMore(.whitespace)
                ZeroOrMore(.newlineSequence)
            }
        }
        let b = right.replacing(with: "", maxReplacements: Int.max) {
            Regex {
                OneOrMore(.whitespace)
                ZeroOrMore(.newlineSequence)
            }
        }
        XCTAssertEqual(a, b)
    }

    func testBasic() throws {
        let fpCore: String = """
            (FPCore (x y z)
             :name "fabs fraction 1"
             (fabs (- (/ (+ x 4) y) (* (/ x y) z))))
            """
        do {
            let fpc = try FPCore(fpCore)
            let tokens = try tokens(fpCore)
            XCTAssertEqual(tokens.count, 54)
            let exp: Expr = .operation(
                .fabs,
                [
                    .operation(
                        .minus,
                        [
                            .operation(
                                .div,
                                [
                                    .operation(
                                        .plus,
                                        [
                                            .symbol(Symbol("x")),
                                            .number(.decnum("4")),
                                        ]),
                                    .symbol(Symbol("y")),
                                ]),
                            .operation(
                                .times,
                                [
                                    .operation(
                                        .div,
                                        [
                                            .symbol(Symbol("x")),
                                            .symbol(Symbol("y")),
                                        ]),
                                    .symbol(Symbol("z")),
                                ]),

                        ])
                ])
            var expected = FPCore(exp)
            let args: [Argument] = [
                .symbol(Symbol("x")),
                .symbol(Symbol("y")),
                .symbol(Symbol("z")),
            ]
            expected.arguments = args
            var props = Properties()
            props.props[Symbol("name")] = .string("\"fabs fraction 1\"")
            expected.properties = props
            XCTAssertEqual(fpc, expected)
            var idk = fpc.description
            idk = idk.replacing(.whitespace, with: "")
            XCTAssertEqual(idk, fpCore.replacing(.whitespace, with: ""))
        } catch LexingError.couldNotConsume(let str) {
            XCTFail(str)
        }
    }
}
