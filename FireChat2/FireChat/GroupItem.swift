//
//  GroupItem.swift
//  FireChat
//
//  Created by T. Andrew Binkowski on 4/25/17.
//  Copyright © 2017 T. Andrew Binkowski. All rights reserved.
//

import Foundation
import Firebase


struct UserItem {
  
  let key: String
  //let name: String
  let ref: FIRDatabaseReference?
  let groups: [String: Bool]
  
  init(snapshot: FIRDataSnapshot) {
    
    
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: Bool]
    //name = snapshotValue["name"] as! String
    groups = snapshotValue["groups"] as! [String: Bool]
    ref = snapshot.ref
  }
  
}


struct GroupItem {
  
  let key: String
  let name: String
  //let members: [String: AnyObject]
  let ref: FIRDatabaseReference?
  
  //  init(name: String, members: [], key: String = "") {
  //    self.key = key
  //    self.name = name
  //    self.members = members
  //    self.ref = nil
  //  }
  
  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    name = snapshotValue["name"] as! String
    //members = nil//snapshotValue["members"] as! [String: AnyObject]
    ref = snapshot.ref
  }
  
}
