//
//  Operation.swift
//  SwiftLogoot
//
//  Created by TonyNguyen on 12/11/18.
//  Copyright © 2018 PN. All rights reserved.
//

import Foundation

public class LogootOperation: Codable {
    // Insert = 0
    // Delete = 1
    public var type: Int
    public var id: AtomIdentifier
    public var content: String
    public init(id: AtomIdentifier, content: String, type: Int) {
        self.id = id
        self.content = content
        self.type = type
    }
}
