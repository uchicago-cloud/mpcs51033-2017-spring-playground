//
//  RemoteConfigManager.swift
//  FireChat
//
//  Created by T. Andrew Binkowski on 4/26/17.
//  Copyright © 2017 T. Andrew Binkowski. All rights reserved.
//


import Foundation
import Firebase

class RemoteConfigManager {
  
  static let sharedInstance = RemoteConfigManager()
  let remoteConfig = FIRRemoteConfig.remoteConfig()
  
  private init() {
    activateDebugMode()
    loadDefaultValues()
  }
  
  func loadDefaultValues() {
    let appDefaults: [String: NSObject] = ["joke_of_the_day": "Default Joke" as NSObject]
    remoteConfig.setDefaults(appDefaults)
  }
  
  ///
  func fetchCloudValues() {
    
    
    let fetchDuration: TimeInterval = 0
    activateDebugMode()
    remoteConfig.fetch(withExpirationDuration: TimeInterval(fetchDuration)) { (status, error) -> Void in
      
      
      if status == .success {
        print("Config fetched!")
        self.remoteConfig.activateFetched()
        
        
        
      } else {
        print("Config not fetched")
        print("Error \(error!.localizedDescription)")
      }
      print("Joke of the day: \(self.remoteConfig["joke_of_the_day"].stringValue!)")
    }
  }
  
  
  func activateDebugMode() {
    let debugSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
    remoteConfig.configSettings = debugSettings!
  }
  
  
  
}
