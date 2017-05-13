//
//  AppDelegate.swift
//  FireChat
//
//  Created by T. Andrew Binkowski on 4/19/17.
//  Copyright © 2017 T. Andrew Binkowski. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
  
  var window: UIWindow?
  
  
  override init() {
    FIRApp.configure()
    RemoteConfigManager.sharedInstance.fetchCloudValues()
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Override point for customization after application launch.
    GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
    

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
  
  // Handle dynamic links
  @available(iOS 8.0, *)
  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    guard let dynamicLinks = FIRDynamicLinks.dynamicLinks() else {
      return false
    }
    let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
      if let dynamiclink = dynamiclink, let _ = dynamiclink.url {
        self.handleIcomingLink(dynamiclink)
      } else {
        print("Error: \(String(describing: error?.localizedDescription))")
      }
    }
    return handled
  }
  
  func handleIcomingLink(_ dynamicLink: FIRDynamicLink) {
    print("DynamicLink: \(dynamicLink)")
    guard let pathComponents = dynamicLink.url?.pathComponents  else { return }
    for component in pathComponents {
      print("\t>> component: \(component)")
    }
  }
  
  
  
  // Open the app from URL callback during Google authentication
  // or from an intial install on a deep link
  @available(iOS 9.0, *)
  func application(_ application: UIApplication,
                   open url: URL,
                   options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    
    
    // Dynamic links
    let dynamicLink = FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url)
    if dynamicLink != nil {
      // Handle the deep link. For example, show the deep-linked content or
      // apply a promotional offer to the user's account.
      // ...
      self.handleIcomingLink(dynamicLink!)
      print("Deep link of first launch or old device")
      return true
    }
    
    return GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                             annotation: [:])
  }
  
  
  // For iOS8 and older
  func application(_ application: UIApplication,
                   open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if let invite = FIRInvites.handle(url, sourceApplication:sourceApplication, annotation:annotation) as? FIRReceivedInvite {
      let matchType =
        (invite.matchType == .weak) ? "Weak" : "Strong"
      print("Invite received from: \(sourceApplication ?? "") Deeplink: \(invite.deepLink)," +
        "Id: \(invite.inviteId), Type: \(matchType)")
      return true
    }
    
    return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  //
  // MARK: - Google Sign In/Out Delegate Methods
  //
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    if let error = error {
      print(error.localizedDescription)
      return
    }
    
    FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: nil)
    
    // Use Google authentication to get credentials
    guard let authentication = user.authentication else { return }
    let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                      accessToken: authentication.accessToken)
    FIRAuth.auth()?.signIn(with: credential) { (user, error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }
    }
  }
  
  
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    // Perform any operations when the user disconnects from app here.
    print("Signed out...")
  }
  
  
  @IBAction func didPressCrash(_ sender: AnyObject) {
    FIRCrashMessage("Forced Crash")
    fatalError()
  }
  
}

