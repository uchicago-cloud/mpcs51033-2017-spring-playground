//
//  MessagesTableViewController.swift
//  FireChat
//
//  Created by T. Andrew Binkowski on 4/19/17.
//  Copyright © 2017 T. Andrew Binkowski. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {
  
  
  let reference = FIRDatabase.database().reference().child("messages")
  let storageRef = FIRStorage.storage().reference()
  
  var messages = [MessageItem]()
  var user: FIRUser?
  
  
  @IBAction func tapNewMessage(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "New Message",
                                  message: "Message",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Post",
                                   style: .default) { _ in
                                    
                                    guard let textField = alert.textFields?.first,
                                      let text = textField.text else {
                                        return
                                    }
                                    
                                    let data = ["name":self.user?.displayName,"text": text]
                                    self.reference.childByAutoId().setValue(data)
    }
    
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    _ = UIAlertAction(title: "Cancel", style: .default) { (_) in
      FIRAnalytics.logEvent(withName: "message-cancelled", parameters: nil)
    }
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Load the data and observe
    uploadFile()
    
    reference.observe(.value, with: { snapshot in
      print(snapshot.value!)
      
      var freshData = [MessageItem]()
      for item in snapshot.children {
        
        let messageItem = MessageItem(snapshot: item as! FIRDataSnapshot)
        freshData.append(messageItem)
      }
      self.messages = freshData
      print(self.messages)
      self.tableView.reloadData()
      
    })
    
    // Keep track of the user
    FIRAuth.auth()!.addStateDidChangeListener { auth, user in
      guard let user = user else { return }
      self.user = user
    }
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return self.messages.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    // Configure the cell...
    let item = messages[indexPath.row]
    cell.textLabel?.text = item.text
    cell.detailTextLabel?.text = item.name
    
    //let reference = storageRef.child("images/kitten.jpg")
    
    // Placeholder image
    //let placeholderImage = UIImage(named: "Placeholder")
    
    // Load the image using SDWebImage
    //cell.imageView?.sd_setImage(with: reference, placeholderImage: placeholderImage)
    
    
    return cell
  }
  
  // Upload a file in our asset catalog; this is just an example
  func uploadFile() {
    // Local file you want to upload
    let data = UIImagePNGRepresentation(UIImage(named:"Kitten")!)
    let kittenRef = storageRef.child("images/kitten.jpg")
    
    
    // Create the file metadata
    let metadata = FIRStorageMetadata()
    metadata.contentType = "image/jpeg"
    
    
    // Upload the file to the path "images/kitten.jpg"
    let _ = kittenRef.put(data!, metadata: nil) { (metadata, error) in
      guard let metadata = metadata else {
        // Uh-oh, an error occurred!
        return
      }
      // Metadata contains file metadata such as size, content-type, and download URL.
      _ = metadata.downloadURL
    }
  }
}
