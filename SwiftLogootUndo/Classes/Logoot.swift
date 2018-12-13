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

    @discardableResult public func insert(content: String) -> Patch {
        if let id = self.generateLineId(
            p: self.idTable[self.idTable.count - 2],
            q: self.idTable.last!,
            N: 1, boundary: 20,
            site: self.site).first {
            let ops = [id].map { LogootOperation(id: $0, content: content, type: 0) }
            let patch = Patch(operations: ops)
            execute(patch: patch)
            return patch
        }
        return Patch(operations: [])
    }

    @discardableResult public func insert(contents: [String], at index: Int) -> Patch {
        let ids = self.generateLineId(p: self.idTable[index], q: self.idTable[index+1], N: contents.count, boundary: 20, site: self.site)
        var ops = [LogootOperation]()
        for (idx, id) in ids.enumerated() {
            ops.append(LogootOperation(id: id, content: contents[idx], type: 0))
        }
        let patch = Patch(operations: ops)
        execute(patch: patch)
        return patch
    }

    @discardableResult public func insert(contents: [String]) -> Patch {
        let ids = self.generateLineId(p: self.idTable[self.idTable.count - 2], q: self.idTable.last!, N: contents.count, boundary: 20, site: self.site)
        var ops = [LogootOperation]()
        for (idx, id) in ids.enumerated() {
            ops.append(LogootOperation(id: id, content: contents[idx], type: 0))
        }
        let patch = Patch(operations: ops)
        execute(patch: patch)
        return patch
    }

    @discardableResult public func insert(content: String, at index: Int) -> Patch {
        if let id = self.generateLineId(p: self.idTable[index], q: self.idTable[index+1], N: 1, boundary: 20, site: self.site).first {
            let ops = [id].map { LogootOperation(id: $0, content: content, type: 0) }
            let patch = Patch(operations: ops)
            execute(patch: patch)
            return patch
        }
        return Patch(operations: [])
    }

    @discardableResult public func delete(at index: Int) -> Patch {
        if index + 1 < idTable.count && index < atoms.count {
            let patch = Patch(operations: [LogootOperation(id: idTable[index + 1], content: atoms[index], type: 1)])
            execute(patch: patch)
            return patch
        }
        return Patch(operations: [])
    }

    public func execute(patch: Patch) {
        for op in patch.operations {
            if op.type == 0 {
                let idx = idTable.insertionIndexOf(elem: op.id, isOrderedBefore: <)
                idTable.insert(op.id, at: idx)
                atoms.insert(op.content, at: idx - 1)
            } else if op.type == 1 {
                if let idx = binarySearch(idTable, key: op.id, range: 0..<idTable.count) {
                    idTable.remove(at: idx)
                    atoms.remove(at: idx - 1)
                }
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

