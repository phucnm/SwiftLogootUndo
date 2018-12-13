//
//  Logoot.swift
//  SwiftLogoot
//
//  Created by TonyNguyen on 12/9/18.
//  Copyright © 2018 PN. All rights reserved.
//

import Foundation

public class LogootDoc: CustomStringConvertible {
    public var site: Int = 0
    public var clock: Int = 0
    public var atoms: [String] = []
    public var idTable: [AtomIdentifier] = []

    public init() {
        idTable.append(AtomIdentifier(positions: [Position(digit: 0, site: 0, clock: 0)]))
        idTable.append(AtomIdentifier(positions: [Position(digit: Int.max, site: 0, clock: 0)]))
    }

    public var description: String {
        return atoms.joined()
    }

    public func insert(content: String) {
        if let id = self.generateLineId(
            p: self.idTable[self.idTable.count - 2],
            q: self.idTable.last!,
            N: 1, boundary: 20,
            site: self.site).first {
            let ops = [id].map { Operation.insert(id: $0, content: content) }
            execute(patch: Patch(operations: ops))
        }
    }

    public func insert(contents: [String], at index: Int) {
        let ids = self.generateLineId(p: self.idTable[index], q: self.idTable[index+1], N: contents.count, boundary: 20, site: self.site)
        var ops = [Operation]()
        for (idx, id) in ids.enumerated() {
            ops.append(Operation.insert(id: id, content: contents[idx]))
        }
        execute(patch: Patch(operations: ops))
    }

    public func insert(contents: [String]) {
        let ids = self.generateLineId(p: self.idTable[self.idTable.count - 2], q: self.idTable.last!, N: contents.count, boundary: 20, site: self.site)
        var ops = [Operation]()
        for (idx, id) in ids.enumerated() {
            ops.append(Operation.insert(id: id, content: contents[idx]))
        }
        execute(patch: Patch(operations: ops))
    }

    public func insert(content: String, at index: Int) {
        if let id = self.generateLineId(p: self.idTable[index], q: self.idTable[index+1], N: 1, boundary: 20, site: self.site).first {
            let ops = [id].map { Operation.insert(id: $0, content: content) }
            execute(patch: Patch(operations: ops))
        }
    }

    public func delete(at index: Int) {
        self.idTable.remove(at: index + 1)
        self.atoms.remove(at: index)
    }

    func execute(patch: Patch) {
        for op in patch.operations {
            switch op {
            case .insert(let id, let content):
                let idx = idTable.insertionIndexOf(elem: id, isOrderedBefore: <)
                idTable.insert(id, at: idx)
                atoms.insert(content, at: idx - 1)
                break
            case .delete(let id , _):
                if let idx = binarySearch(idTable, key: id, range: 0..<idTable.count) {
                    idTable.remove(at: idx)
                    atoms.remove(at: idx - 1)
                }
                break
            }
        }
    }

    private func generateLineId(p: AtomIdentifier, q: AtomIdentifier, N: Int, boundary: Int, site: Int) -> [AtomIdentifier] {
        var list = [AtomIdentifier]()
        var index = 0
        var interval = 0
        while interval < N {
            index += 1
            interval = q.prefix(index) - p.prefix(index) - 1
        }
        let step = min(interval / N, boundary)
        var r = p.prefix(index)
        for _ in 1...N {
            list.append(constructId(r: r + Int.random(in: 1...step), p: p, q: q, site: site))
            r += step
        }
        return list
    }

    private func constructId(r: Int, p: AtomIdentifier, q: AtomIdentifier, site: Int) -> AtomIdentifier {
        var positions = [Position]()
        let digits = r.extractDigits(between: p, and: q)
        for i in 0..<digits.count {
            let d = digits[i]
            if i < p.positions.count && d == p.positions[i].digit {
                positions.append(Position(digit: d, site: p.positions[i].site, clock: p.positions[i].clock))
            } else if i < q.positions.count && d == q.positions[i].digit {
                positions.append(Position(digit: d, site: q.positions[i].site, clock: q.positions[i].clock))
            } else {
                positions.append(Position(digit: d, site: site, clock: clock))
                clock += 1
            }
        }
        return AtomIdentifier(positions: positions)
    }
}

