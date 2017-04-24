//
//  ViewController.swift
//  FireChat
//
//  Created by T. Andrew Binkowski on 4/19/17.
//  Copyright © 2017 T. Andrew Binkowski. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
  
  ///
  @IBOutlet weak var signInButton: GIDSignInButton!
  
  ///
  @IBAction func tapSignOut(_ sender: UIButton) {
    print("Sign out")
    let firebaseAuth = FIRAuth.auth()
    do {
      try firebaseAuth?.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
    
  }
  
  //
  // MARK: -
  //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Login automically or call dialogue
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().signIn()
    
    // Setup listener
    FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
      
      // Automatically segue after a successfull login; users seem to
      // hang around while developing, you may need to clean and remove
      // app from simulator
      if user != nil {
        self.performSegue(withIdentifier: "segueToMessages", sender: nil)
      }
    }
  }
  
  deinit {
  }
}

