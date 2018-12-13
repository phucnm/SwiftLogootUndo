//
//  Operation.swift
//  SwiftLogoot
//
//  Created by TonyNguyen on 12/11/18.
//  Copyright © 2018 PN. All rights reserved.
//

import Foundation

public enum Operation {
    case insert(id: AtomIdentifier, content: String)
    case delete(id: AtomIdentifier, content: String)
}
