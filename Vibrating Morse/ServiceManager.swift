// Copyright 2016-2017, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// Source    https://www.ralfebert.de/tutorials/ios-swift-multipeer-connectivity/

import Foundation
import MultipeerConnectivity

protocol ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager : ColorServiceManager, connectedDevices: [String])
    func colorChanged(manager : ColorServiceManager, colorString: String)
    
}

class ColorServiceManager : NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let ColorServiceType = "example-color"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    var delegate : ColorServiceManagerDelegate?
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ColorServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ColorServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    func send(colorName : String) {
        NSLog("%@", "sendColor: \(colorName) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(colorName.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
        
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
}

extension ColorServiceManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
}

extension ColorServiceManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
}

extension ColorServiceManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
            session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        self.delegate?.colorChanged(manager: self, colorString: str)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}


//
//  ViewController.swift
//  Vibrating Morse
//
//  Created by Alexander Christiaan Brink on 2017/11/27.
//  Copyright © 2017 Andile. All rights reserved.
//
/*
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var connectionsLabel: UILabel!
    
    let colorService = ColorServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        colorService.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var change: UIButton!
    @IBAction func changePressed(_ sender: Any) {
        print("YO")
        colorService.send(colorName: "yellow")
        
    }
    
}

extension ViewController : ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: ColorServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print("Connections: \(connectedDevices)")
        }
    }
    
    func colorChanged(manager: ColorServiceManager, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "red":
                NSLog("%@", "Unknown color value received: \(colorString)")
            case "yellow":
                NSLog("%@", "Unknown color value received: \(colorString)")
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }
}*/
