//
//  SwiftLogootTests.swift
//  SwiftLogootTests
//
//  Created by TonyNguyen on 12/9/18.
//  Copyright © 2018 PN. All rights reserved.
//

import XCTest
@testable import SwiftLogootUndo

class SwiftLogootTests: XCTestCase {

    var document: LogootDoc!

    override func setUp() {
        document = LogootDoc()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertString() {
        document.insert(content: "Hehe\n")
        document.insert(content: "Hello, world!")
        XCTAssertEqual(document.idTable.count, 4)
        XCTAssertEqual(document.description, "Hehe\nHello, world!")
    }

    func testInsertStringAtIndex() {
        document.insert(content: "world!")
        document.insert(content: "Hello, ", at: 0)
        XCTAssertEqual(document.idTable.count, 4)
        XCTAssertEqual(document.description, "Hello, world!")
    }

    func testInsertPatchAtIndex() {
        document.insert(contents: ["Hello ", "world!"], at: 0)
        XCTAssertEqual(document.idTable.count, 4)
        XCTAssertEqual(document.description, "Hello world!")
    }

    func testInsertPatch() {
        document.insert(contents: ["Hello ", "world!"])
        XCTAssertEqual(document.idTable.count, 4)
        XCTAssertEqual(document.description, "Hello world!")
    }

    func testDelete() {
        document.insert(content: "H")
        document.insert(content: "e")
        document.insert(content: "l")
        document.insert(content: "l")
        document.insert(content: "o")
        document.insert(content: " ")
        document.insert(content: "w")
        document.insert(content: "o")
        document.insert(content: "r")
        document.insert(content: "l")
        document.insert(content: "d")
        document.delete(at: 5)
        XCTAssertEqual(document.description, "Helloworld")
    }
}
