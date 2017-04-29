//
//  MessageItem.swift
//  FireChat
//
//  Created by T. Andrew Binkowski on 4/19/17.
//  Copyright © 2017 T. Andrew Binkowski. All rights reserved.
//

import Foundation
import Firebase


struct MessageItem {
  
  let key: String
  let name: String
  let text: String
  let ref: FIRDatabaseReference?
  
  init(name: String, text: String, key: String = "") {
    self.key = key
    self.name = name
    self.text = text
    self.ref = nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    name = snapshotValue["user"] as! String
    text = snapshotValue["text"] as! String
    ref = snapshot.ref
  }
  
}
