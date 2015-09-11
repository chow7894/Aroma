/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import MultipeerConnectivity

protocol MultipeerConnecivityServiceDelegate {
  func didChangeState(state: MCSessionState, forPeer: MCPeerID)
  func didReceiveData(data: NSData, fromPeer: MCPeerID)
  
  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController)
  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController)
}

private let _sharedService = MultipeerConnectivityService()

class MultipeerConnectivityService: NSObject {
  
  private var advertiserAssistant: MCAdvertiserAssistant?
  private var browserViewController: MCBrowserViewController?
  private var session: MCSession?
  
  class var sharedService: MultipeerConnectivityService {
    return _sharedService
  }
  
  var delegate: MultipeerConnecivityServiceDelegate?
  
  func advertiseWithName(name: String) {
    let peerId = MCPeerID(displayName: name)
    session = MCSession(peer: peerId)
    session?.delegate = self
    advertiserAssistant = MCAdvertiserAssistant(serviceType: "rzw-waitlist", discoveryInfo: nil, session: session)
    
    advertiserAssistant?.start()
  }
  
  func presentBrowserFromViewController(presentingController: UIViewController, peerName: String) {
    let peerId = MCPeerID(displayName: peerName)
    session = MCSession(peer: peerId)
    browserViewController = MCBrowserViewController(serviceType: "rzw-waitlist", session: session)
    browserViewController?.delegate = self
    presentingController.presentViewController(browserViewController!, animated: true, completion: nil)
  }
  
  func sendMessage(data: NSData, error: NSErrorPointer) {
    session?.sendData(data, toPeers: session?.connectedPeers, withMode: .Reliable, error: error)
    println("Datat sent to nearbly devices")
  }
}


extension MultipeerConnectivityService: MCSessionDelegate {
  
  func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
    delegate?.didReceiveData(data, fromPeer: peerID)
  }
  
  func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    delegate?.didChangeState(state, forPeer: peerID)
  }
  
  func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    // streaming not implemented as it will not be used for this app
  }
  
  func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    // resources not implemented as it will not be used for this app
  }
  
  func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    // resources not implemented as it will not be used for this app
  }
}

extension MultipeerConnectivityService: MCBrowserViewControllerDelegate {
  
  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
    delegate?.browserViewControllerDidFinish(browserViewController)
  }
  
  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
    delegate?.browserViewControllerWasCancelled(browserViewController)
  }
}