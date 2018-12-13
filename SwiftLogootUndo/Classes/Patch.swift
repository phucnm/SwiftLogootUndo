//
//  Patch.swift
//  SwiftLogoot
//
//  Created by TonyNguyen on 12/12/18.
//  Copyright © 2018 PN. All rights reserved.
//

import Foundation

public struct Patch {
    let id: String
    var operations: [Operation]
    var degree: Int

    init(operations: [Operation]) {
        id = UUID().uuidString
        self.operations = operations
        degree = 0
    }
}
