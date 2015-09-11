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

import UIKit
import CoreLocation
import MultipeerConnectivity

class RestaurantDetailViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var motdLabel: UILabel!
  @IBOutlet var motdTextView: UITextView!
  @IBOutlet var reserveATableButton: UIButton!
  
  var restaurant: Restaurant?
  var containingViewController: UIViewController?
  
  private var connectedToHostStand: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.image = restaurant?.image
    motdLabel.text = restaurant?.motdHeader
    motdTextView.text = restaurant?.motdBody
  }
  
  @IBAction func reserveATable(sender: UIButton) {
    MultipeerConnectivityService.sharedService.delegate = self
    if let containingViewController = containingViewController {
      MultipeerConnectivityService.sharedService.presentBrowserFromViewController(containingViewController, peerName: "Guest")
    } else {
      MultipeerConnectivityService.sharedService.presentBrowserFromViewController(self, peerName: "Guest")
    }
  }
}

extension RestaurantDetailViewController: MultipeerConnecivityServiceDelegate {
  
  func didChangeState(state: MCSessionState, forPeer: MCPeerID) {
    // do nothing
  }
  
  func didReceiveData(data: NSData, fromPeer: MCPeerID) {
    // do nothing
  }
  
  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
    browserViewController.dismissViewControllerAnimated(true) {
      let reserveTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ReserveTableViewController") as! ReserveTableViewController
      reserveTableViewController.completion = { name, partySize in
        var sendError: NSError?
        let guestInfo = ["name": name, "partySize": partySize]
        let data = NSKeyedArchiver.archivedDataWithRootObject(guestInfo)
        MultipeerConnectivityService.sharedService.sendMessage(data, error: &sendError)
      }
      if let containingViewController = self.containingViewController {
        self.containingViewController?.presentViewController(reserveTableViewController, animated: true, completion: nil)
      } else {
        self.presentViewController(reserveTableViewController, animated: true, completion: nil)
      }
    }
  }
  
  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
    browserViewController.dismissViewControllerAnimated(true, completion: nil)
  }
  
}