//
//  AppDelegate.swift
//  CloudyWithAChanceOfErros
//
//  Created by T. Andrew Binkowski on 5/2/17.
//  Copyright © 2017 T. Andrew Binkowski. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Set the notification delegate
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      } else {
        application.registerForRemoteNotifications()
      }
    }
    UNUserNotificationCenter.current().delegate = self
    
    // Register subscriptions
    CloudKitManager.sharedInstance.registerSubscriptionsWithIdentifier("id2")
    CloudKitManager.sharedInstance.registerSilentSubscriptionsWithIdentifier("id3")
    //configureUserNotificationsCenter()
    
    if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
      // 2
      let aps = notification["aps"] as! [String: AnyObject]
      print("APS: \(aps)")
      // 3
      //(window?.rootViewController as? UITabBarController)?.selectedIndex = 1
    }
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
  
  //
  // MARK: - Notifications
  //
  
  /*
   func configureUserNotificationsCenter() {
   // Configure User Notification Center
   
   // Define Actions
   let actionReadLater = UNNotificationAction(identifier: "action1", title: "Read Later", options: [])
   let actionShowDetails = UNNotificationAction(identifier: "action2", title: "Show Details", options: [.foreground])
   let actionUnsubscribe = UNNotificationAction(identifier: "action3", title: "Unsubscribe", options: [.destructive, .authenticationRequired])
   
   // Define Category
   let tutorialCategory = UNNotificationCategory(identifier: "ActionCategory", actions: [actionReadLater, actionShowDetails, actionUnsubscribe], intentIdentifiers: [], options: [])
   
   // Register Category
   UNUserNotificationCenter.current().setNotificationCategories([tutorialCategory])
   }
   */
  
  //
  //
  //
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert,.badge,.sound])
  }
  
  
  //
  //
  //
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    let aps = userInfo["aps"] as! [String: AnyObject]
    
    if (aps["content-available"] as? NSString)?.integerValue == 1 {
      // Pull data
      completionHandler(.newData)
    } else  {
      completionHandler(.newData)
    }
  }
  
  //
  // Called from Action button and.or
  //
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    
    
    let response = response.notification.request.content
    print("Notification: \(response)")
    //    switch response.actionIdentifier {
    //    case Notification.Action.readLater:
    //      print("Save Tutorial For Later")
    //    case Notification.Action.unsubscribe:
    //      print("Unsubscribe Reader")
    //    default:
    //      print("Other Action")
    //    }
    
    completionHandler()
  }
}
