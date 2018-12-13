//
//  Position.swift
//  SwiftLogoot
//
//  Created by TonyNguyen on 12/12/18.
//  Copyright © 2018 PN. All rights reserved.
//

import Foundation

public struct Position: Comparable, Equatable, CustomStringConvertible {
    var digit: Int
    var site: Int
    var clock: Int

    public var description: String {
        return "<\(digit), \(site), \(clock)>"
    }

    public static func < (lhs: Position, rhs: Position) -> Bool {
        if lhs.digit < rhs.digit {
            return true
        } else if lhs.digit == rhs.digit && lhs.site < rhs.site {
            return true
        } else if lhs.digit == rhs.digit && lhs.site == rhs.site {
            return lhs.clock < rhs.clock
        }
        return false
    }
}
