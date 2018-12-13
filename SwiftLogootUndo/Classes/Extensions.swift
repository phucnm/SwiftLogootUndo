//
//  Extensions.swift
//  SwiftLogoot
//
//  Created by TonyNguyen on 12/11/18.
//  Copyright © 2018 PN. All rights reserved.
//

import Foundation
import UIKit

public extension UITextView {
    var currentCursor: Int {
        get {
            guard let currentPos = selectedTextRange else {
                return 0
            }
            return offset(from: beginningOfDocument, to: currentPos.start)
        }
    }
}

//https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Search
public func binarySearch<T: Comparable>(_ a: [T], key: T, range: Range<Int>) -> Int? {
    if range.lowerBound >= range.upperBound {
        // If we get here, then the search key is not present in the array.
        return nil

    } else {
        // Calculate where to split the array.
        let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2

        // Is the search key in the left half?
        if a[midIndex] > key {
            return binarySearch(a, key: key, range: range.lowerBound ..< midIndex)

            // Is the search key in the right half?
        } else if a[midIndex] < key {
            return binarySearch(a, key: key, range: midIndex + 1 ..< range.upperBound)

            // If we get here, then we've found the search key!
        } else {
            return midIndex
        }
    }
}

// borrowed from
// https://stackoverflow.com/questions/26678362/
public extension Array {
    func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }

//    func binary
}

public extension Array where Element == Int {
    func inRange(p: AtomIdentifier, q: AtomIdentifier) -> Bool {
        var largerP = false
        var smallerQ = false
        for i in 0..<self.count {
            if largerP && smallerQ {
                return true
            }
            if !largerP && i < p.positions.count {
                if self[i] < p.positions[i].digit {
                    return false
                } else if self[i] > p.positions[i].digit {
                    largerP = true
                }
            }
            if !smallerQ && i < q.positions.count {
                if self[i] > q.positions[i].digit {
                    return false
                } else if self[i] < q.positions[i].digit {
                    smallerQ = true
                }
            }
        }
        return true
    }
}

public extension Int {
    /// Extract digits from a number between two positions
    ///
    /// - Parameters:
    ///   - p: left position
    ///   - q: right position
    /// - Returns: digits array
    func extractDigits(between p: AtomIdentifier, and q: AtomIdentifier) -> [Int] {
        return extractDigits([], p: p, q: q)
    }

    //Private recursive method
    private func extractDigits(_ initialDigits: [Int], p: AtomIdentifier, q: AtomIdentifier) -> [Int] {
        var digits = initialDigits
        let string = NSString(string: String(self))
        for i in (1...string.length).reversed() {
            if let digit = Int(string.substring(to: i)),
                (digits + [digit]).inRange(p: p, q: q) {
                digits += [digit]
                return [digit] + (Int(string.substring(from: i))?.extractDigits(digits, p: p, q: q) ?? [])
            }
        }
        return digits
    }
}
