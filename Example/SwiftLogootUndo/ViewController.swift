//
//  ViewController.swift
//  SwiftLogootUndo
//
//  Created by phucnguyenpr@gmail.com on 12/12/2018.
//  Copyright (c) 2018 phucnguyenpr@gmail.com. All rights reserved.
//

import UIKit
import SwiftLogootUndo
import MultipeerConnectivity

class ViewController: UIViewController, UITextViewDelegate, PeerManagerDelegate {
    let doc = LogootDoc()
    @IBOutlet weak var textView: UITextView!
    let queue = DispatchQueue.init(label: "com.logoot.internalqueue")
    let peerManager = PeerManager()
    //Set this to true to simulate remote insertions.
    let insertionSimulation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        if insertionSimulation { simulateInsertion() }
        peerManager.delegate = self
        peerManager.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        peerManager.stop()
    }

    private func simulateInsertion() {
        var i = 0
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (_) in
            let currentSelectedRange = self.textView.selectedTextRange
            let currentCursor = self.textView.currentCursor
            self.queue.async {
                self.doc.insert(content: "\(i)\t", at: self.doc.idTable.count / 2 - 1)
                print(self.doc.atoms)
                print(self.doc.idTable)
                DispatchQueue.main.async {
                    i += 1

                    self.textView.text = self.doc.description
                    if let range = currentSelectedRange {
                        if currentCursor >= self.doc.idTable.count / 2 - 1 {
                            let offset = "\(i)\t".count
                            if let newPosStart = self.textView.position(from: range.start, offset: offset),
                                let newPosEnd = self.textView.position(from: range.end, offset: offset) {
                                self.textView.selectedTextRange = self.textView.textRange(from: newPosStart, to: newPosEnd)
                            }
                        } else {
                            self.textView.selectedTextRange = self.textView.textRange(from: range.start, to: range.end)
                        }
                    }
                }
            }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isBackspace() {
            let patch = self.doc.delete(at: range.location)
            self.peerManager.propagate(patch: patch)
            print(self.doc.atoms)
            print(self.doc.idTable)
        }
        let patch = self.doc.insert(contents: Array(text).map { String($0) }, at: range.location)
        self.peerManager.propagate(patch: patch)
        print(self.doc.atoms)
        print(self.doc.idTable)

        return true
    }

    //MARK: PeerManager delegates
    func peerManager(peerManager: PeerManager, didUpdate peers: [MCPeerID]) {
        print("Connected peers: \(peers)")
    }

    func peerManager(peerManager: PeerManager, didReceive patch: Patch, from peer: MCPeerID) {
        queue.async {
            self.doc.execute(patch: patch)
            print(self.doc.atoms)
            print(self.doc.idTable)
            let text = self.doc.description
            DispatchQueue.main.async {
                self.textView.text = text
            }

        }
    }
}

