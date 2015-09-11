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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  var locationManager: CLLocationManager?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    //1
    BeaconMonitoringService.sharedInstance.stopMonitoringAllRegions()
    
    //2
    for restaurant in RestaurantDetailService.sharedService.restaurants {
      BeaconMonitoringService.sharedInstance.startMonitoringBeaconWithUUID(restaurant.uuid, major: 0, minor: 0, identifier: restaurant.name, onEntry: true, onExit: true)
    }
    
    //3
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    
    //4
    if CLLocationManager.authorizationStatus() == .NotDetermined {
      if locationManager?.respondsToSelector("requestAlwaysAuthorization") == true {
        locationManager?.requestAlwaysAuthorization()
      }
    }
    
    //5
    if UIApplication.instancesRespondToSelector("registerUserNotificationSettings:") {
      application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: nil))
    }
    
    
    
    
    return true
  }
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    if let uuidString = notification.userInfo?["uuid"] as? String {
      if let uuid = NSUUID(UUIDString: uuidString) {
        if let restaurant = RestaurantDetailService.sharedService.restaurant(uuid) {
          let restaurantDetailViewController = window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailViewController") as! RestaurantDetailViewController
          restaurantDetailViewController.restaurant = restaurant
          
          if let navController = window?.rootViewController as? UINavigationController {
            let mainViewController = navController.topViewController as! MainViewController
            mainViewController.scrollTo(restaurant)
          }
        }
      }
    }
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
    if let beaconRegion = region as? CLBeaconRegion {
      if let restaurant = RestaurantDetailService.sharedService.restaurant(beaconRegion.proximityUUID) {
        let userInfo: [String: AnyObject] = ["restaurant": restaurant, "state": state.rawValue]
        NSNotificationCenter.defaultCenter().postNotificationName("DidDetermineRegionState", object: self, userInfo: userInfo)
      }
    }
  }
  
  func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
    if let beaconRegion = region as? CLBeaconRegion {
      if let restaurant = RestaurantDetailService.sharedService.restaurant(beaconRegion.proximityUUID) {
        let notification = UILocalNotification()
        notification.userInfo = ["uuid": restaurant.uuid.UUIDString]
        notification.alertBody = "Smell that? Looks like you're near \(restaurant.name)!"
        notification.soundName = "Default"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        NSNotificationCenter.defaultCenter().postNotificationName("DidEnterRegion", object: self, userInfo: ["restaurant": restaurant])
      }
    }
  }
  
  func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
    if let beaconRegion = region as? CLBeaconRegion {
      if let restaurant = RestaurantDetailService.sharedService.restaurant(beaconRegion.proximityUUID) {
        let notification = UILocalNotification()
        notification.alertBody = "We hope you enjoy the smells and more of \(restaurant.name). See you next time!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        NSNotificationCenter.defaultCenter().postNotificationName("DidExtitRegion", object: self, userInfo: ["restaurant": restaurant])
      }
    }
  }
}


