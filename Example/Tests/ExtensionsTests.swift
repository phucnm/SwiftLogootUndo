//
//  ExtensionsTests.swift
//  SwiftLogootTests
//
//  Created by TonyNguyen on 12/12/18.
//  Copyright © 2018 PN. All rights reserved.
//

import XCTest
@testable import SwiftLogootUndo

class ExtensionsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBinarySearch() {
        let idx = binarySearch([1, 2, 3, 4, 5], key: 4, range: 0..<5)
        XCTAssertEqual(idx, 3)
        XCTAssertNil(binarySearch([1, 2, 3, 4, 5], key: 6, range: 0..<5))
    }

    func testBinaryInsertion() {
        let idx = [1, 2, 3, 5].insertionIndexOf(elem: 4, isOrderedBefore: <)
        XCTAssertEqual(idx, 3)
    }

    func testExtractingDigits() {
        let p = AtomIdentifier(positions: [
            Position(digit: 2, site: 4, clock: 7),
            Position(digit: 59, site: 0, clock: 0)
            ])
        let q = AtomIdentifier(positions: [
            Position(digit: 10, site: 0, clock: 0),
            Position(digit: 20, site: 0, clock: 0)
            ])
        let res = 320.extractDigits(between: p, and: q)
        print(res)
        XCTAssert(res.count == 2)
    }

    func testInRange() {
        let p = AtomIdentifier(positions: [
            Position(digit: 2, site: 4, clock: 7),
            Position(digit: 59, site: 9, clock: 5)
            ])
        let q = AtomIdentifier(positions: [
            Position(digit: 10, site: 5, clock: 3),
            Position(digit: 20, site: 3, clock: 6),
            Position(digit: 3, site: 3, clock: 9)
            ])
        XCTAssertTrue([3, 20].inRange(p: p, q: q))
        XCTAssertTrue([6, 51].inRange(p: p, q: q))
        XCTAssertTrue([10, 19].inRange(p: p, q: q))
    }

    func testPrefix() {
        //Adopt from the paper
        let p = AtomIdentifier(positions: [
            Position(digit: 2, site: 4, clock: 7),
            Position(digit: 59, site: 9, clock: 5)
            ])
        let q = AtomIdentifier(positions: [
            Position(digit: 10, site: 5, clock: 3),
            Position(digit: 20, site: 3, clock: 6),
            Position(digit: 3, site: 3, clock: 9)
            ])
        XCTAssertEqual(p.prefix(1), 2)
        XCTAssertEqual(p.prefix(2), 259)
        XCTAssertEqual(p.prefix(3), 2590)
        XCTAssertEqual(q.prefix(1), 10)
        XCTAssertEqual(q.prefix(2), 1020)
        XCTAssertEqual(q.prefix(3), 10203)
    }
}
