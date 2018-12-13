//
//  Patch.swift
//  SwiftLogoot
//
//  Created by TonyNguyen on 12/12/18.
//  Copyright © 2018 PN. All rights reserved.
//

import Foundation

public struct Patch: Codable {
    public let id: String
    public var operations: [LogootOperation]
    public var degree: Int

    public init(operations: [LogootOperation]) {
        id = UUID().uuidString
        self.operations = operations
        degree = 0
    }
}
