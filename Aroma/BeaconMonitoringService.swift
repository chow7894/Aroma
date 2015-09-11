//
//  BeaconMonitoringService.swift
//  Aroma
//
//  Created by Damien on 9/9/15.
//  Copyright (c) 2015 Ray Wenderlich LLC. All rights reserved.
//

import Foundation
import CoreLocation

private let _sharedInstance = BeaconMonitoringService()

class BeaconMonitoringService: NSObject {
  private let locationManager = CLLocationManager()
  
  class var sharedInstance: BeaconMonitoringService {
    return _sharedInstance
  
  }
  
  func startMonitoringBeaconWithUUID(UUID: NSUUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String, onEntry: Bool, onExit: Bool) {
    let region = CLBeaconRegion(proximityUUID: UUID, major: major, minor: minor, identifier: identifier)
    region.notifyOnEntry = onEntry
    region.notifyOnExit = onExit
    region.notifyEntryStateOnDisplay = true
    locationManager.startMonitoringForRegion(region)
  }
  
  func stopMonitoringAllRegions() {
    for region in locationManager.monitoredRegions {
      locationManager.stopMonitoringForRegion(region as! CLRegion)
    }
  }
  
    
    
    
}