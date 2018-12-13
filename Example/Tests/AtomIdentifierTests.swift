//
//  AtomIdentifierTests.swift
//  SwiftLogootTests
//
//  Created by TonyNguyen on 12/12/18.
//  Copyright © 2018 PN. All rights reserved.
//

import XCTest
@testable import SwiftLogootUndo

class AtomIdentifierTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOperator() {
        //adopt from paper
        let lb = AtomIdentifier(positions: [Position(digit: 0, site: 0, clock: 0)])
        let atom1 = AtomIdentifier(positions: [
            Position(digit: 131, site: 1, clock: 4)
            ])
        let atom2 = AtomIdentifier(positions: [
            Position(digit: 131, site: 1, clock: 4),
            Position(digit: 2471, site: 5, clock: 23),
            ])
        let atom3 = AtomIdentifier(positions: [
            Position(digit: 131, site: 3, clock: 2)
            ])
        let le = AtomIdentifier(positions: [Position(digit: Int.max - 1, site: 0, clock: 0)])
        XCTAssertTrue(lb < atom1)
        XCTAssertTrue(atom1 < atom2)
        XCTAssertTrue(atom2 < atom3)
        XCTAssertTrue(atom3 < le)
    }
}
