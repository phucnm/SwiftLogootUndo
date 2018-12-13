//
//  PeerManager.swift
//  SwiftLogootUndo_Example
//
//  Created by TonyNguyen on 12/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import SwiftLogootUndo

protocol PeerManagerDelegate: class {
    func peerManager(peerManager: PeerManager, didUpdate peers: [MCPeerID])
    func peerManager(peerManager: PeerManager, didReceive patch: Patch, from peer: MCPeerID)
}

class PeerManager: NSObject, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate {
    let serviceType = "DemoLogoot-Undo"
    let peerId = MCPeerID(displayName: UIDevice.current.name)
    var serviceAdvertiser: MCNearbyServiceAdvertiser?
    var serviceBrowser: MCNearbyServiceBrowser?
    weak var delegate: PeerManagerDelegate?

    lazy var session: MCSession = {
        let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        return session
    }()

    override init() {
        super.init()
    }

    func start() {
        browse()
        advertise()
    }

    func stop() {
        stopBrowsing()
        stopAdvertising()
    }

    func propagate(patch: Patch) {
        do {
            let data = try JSONEncoder().encode(patch)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("oops got an error \(error)")
        }

    }

    private func browse() {
        serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceType)
        serviceBrowser?.delegate = self
        serviceBrowser?.startBrowsingForPeers()
    }

    private func stopBrowsing() {
        serviceBrowser?.stopBrowsingForPeers()
    }

    private func advertise() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
        serviceAdvertiser?.delegate = self
        serviceAdvertiser?.startAdvertisingPeer()
    }

    private func stopAdvertising() {
        serviceAdvertiser?.stopAdvertisingPeer()
    }

    //MARK: Browsing delegate

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 5)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Browser lost peer \(peerID)")
    }

    //MARK: Advertising delegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }

    //MARK: Session delegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("Peer \(peerID) did change state \(state.rawValue)")
        delegate?.peerManager(peerManager: self, didUpdate: session.connectedPeers)
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let patch = try JSONDecoder().decode(Patch.self, from: data)
            let string = String(data: data, encoding: .utf8)
            print(string!)
            delegate?.peerManager(peerManager: self, didReceive: patch, from: peerID)
        } catch {
            print("Parsing patch error \(error)")
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
}
