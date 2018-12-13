//
//  AtomIdentifier.swift
//  SwiftLogoot
//
//  Created by TonyNguyen on 12/12/18.
//  Copyright © 2018 PN. All rights reserved.
//

import Foundation

public struct AtomIdentifier: Comparable, CustomStringConvertible {
    let positions: [Position]

    init(positions: [Position]) {
        self.positions = positions
    }

    public var description: String {
        return positions.map { $0.description }.joined()
    }

    public static func < (lhs: AtomIdentifier, rhs: AtomIdentifier) -> Bool {
        for j in 0..<rhs.positions.count {
            //Avoid crashing
            if j < lhs.positions.count {
                if lhs.positions[j] < rhs.positions[j] {
                    return true
                }
                if lhs.positions[j] > rhs.positions[j] {
                    return false
                }
            }
            //The two positions are equal and j = lhs size + 1
            if j >= lhs.positions.count {
                return true
            }
        }
        return false
    }

    func prefix(_ upTo: Int) -> Int {
        var number = ""
        for i in 0..<upTo {
            number += i < positions.count ? String(positions[i].digit) : "0"
        }
        return Int(number) ?? 0
    }
}
