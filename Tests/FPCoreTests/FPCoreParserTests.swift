import XCTest

@testable import FPCore

final class FPCoreParserTests: XCTestCase {
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
        } catch LexingError.couldNotConsume(let str) {
            XCTFail(str)
        }
    }
}
