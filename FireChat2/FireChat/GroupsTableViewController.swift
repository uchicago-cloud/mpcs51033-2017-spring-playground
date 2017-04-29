//
//  GroupsTableViewController.swift
//  FireChat
//
//  Created by T. Andrew Binkowski on 4/25/17.
//  Copyright © 2017 T. Andrew Binkowski. All rights reserved.
//

import UIKit
import Firebase

class GroupsTableViewController: UITableViewController {
  let reference = FIRDatabase.database().reference().child("groups")
  var referenceHandle: FIRDatabaseHandle?
  
  var groups = [GroupItem]()
  var user: FIRUser?
  
  //
  // MARK: -
  //
  deinit {
    if let refHandle = referenceHandle {
      reference.removeObserver(withHandle: refHandle)
    }
  }
  
  @IBAction func addGroup(_ sender: Any) {
    let newReference = reference.childByAutoId()
    //let firstUser = self.user?.uid
    let channelItem = [ "name" : "dance"]
    //                    "members" : [[firstUser : true]]]
    newReference.setValue(channelItem)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.user = FIRAuth.auth()?.currentUser
    
    // Get the user groups
    let reference = FIRDatabase.database().reference().child("users").child((self.user?.uid)!)
    //.child("groups")
    reference.observeSingleEvent(of: .value, with: { snapshot in
      if(snapshot.exists()) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        let name = snapshotValue["name"] as! String
        let groups = snapshotValue["groups"] as! [String: AnyObject]
        print("-------------> \(name) \(groups) \n\(snapshotValue)")
        
        
        self.getGroups(Array(groups.keys))
      }
    })
    
    
  }
  
  /// Retrieve all the groups from the database
  func getGroups(_ groups: [String]) {
    referenceHandle = reference.observe(.value, with: { snapshot in
      print(snapshot.value!)
      
      var freshData = [GroupItem]()
      for item in snapshot.children {
        let groupItem = GroupItem(snapshot: item as! FIRDataSnapshot)
        if groups.contains(groupItem.key) {
          freshData.append(groupItem)
        }
      }
      self.groups = freshData
      print(self.groups)
      self.tableView.reloadData()
    })
  }
  
  
  
  //  func getUserGroups() -> [GroupItem] {
  //
  //    let reference = FIRDatabase.database().reference().child("users").child((self.user?.uid)!).child("groups")
  //
  //    reference.observeSingleEvent(of: .value, with: { snapshot in
  //
  //      if(snapshot.exists()) {
  //
  //        let groups = snapshot.value as! [String: Bool]
  //        for group in groups {
  //          let g = FIRDatabase.database().reference().child("groups").child(group)
  //          g.observeSingleEventOfType(.value, withBlock: { snapshot in
  //            snapshot.value
  //          })
  //        }
  //
  //      }
  //    }
  
  
  
  
  //
  // MARK: - Table view data source
  //
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.groups.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    // Configure the cell...
    let item = groups[indexPath.row]
    cell.textLabel?.text = item.name
    //cell.detailTextLabel?.text = item.name
    
    
    return cell
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as! MessagesTableViewController
    let index = tableView.indexPathsForSelectedRows?.first?.row
    vc.group = groups[index!]
    
  }
  
}
