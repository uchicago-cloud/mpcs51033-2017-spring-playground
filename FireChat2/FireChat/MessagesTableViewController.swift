//
//  MessagesTableViewController.swift
//  FireChat
//
//  Created by T. Andrew Binkowski on 4/19/17.
//  Copyright © 2017 T. Andrew Binkowski. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController, FIRInviteDelegate {
  
  
  var reference: FIRDatabaseReference!
  let storageRef = FIRStorage.storage().reference()
  
  var messages = [MessageItem]()
  var user: FIRUser?
  
  var group: GroupItem!
  
  @IBAction func tapInvite(_ sender: UIBarButtonItem) {
/*
    if let invite = FIRInvites.inviteDialog() {
   
      
      invite.setInviteDelegate(self as FIRInviteDelegate)
      
      // NOTE: You must have the App Store ID set in your developer console project
      // in order for invitations to successfully be sent.
      
      // A message hint for the dialog. Note this manifests differently depending on the
      // received invitation type. For example, in an email invite this appears as the subject.
      invite.setMessage("Try this out!\n -\(FIRAuth.auth()?.currentUser?.displayName ?? "")")
      // Title for the dialog, this is what the user sees before sending the invites.
      invite.setTitle("Fire Chat 🔥")
      invite.setDeepLink("https://a795j.app.goo.gl/6SuK")
      invite.setCallToActionText("Install!")
      invite.setCustomImage("http://i.telegraph.co.uk/multimedia/archive/02830/cat_2830677b.jpg")
      invite.open()
    }
 */
      
    // Standard UI way

    let myDynamicLink = "https://a795j.app.goo.gl/6SuK"
    let msg = "Hey, check this out: " + myDynamicLink
    let shareSheet = UIActivityViewController(activityItems: [ msg ],
                                              applicationActivities: nil)
    shareSheet.popoverPresentationController?.sourceView = self.view
    self.present(shareSheet, animated: true, completion: nil)

  }
  
  
  private func inviteFinished(withInvitations invitationIds: [Any], error: Error?) {
    if let error = error {
      print("Failed: \(error.localizedDescription)")
    } else {
      print("Invitations sent")
    }
  }
  
  @IBAction func tapNewMessage(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "New Message", message: "Message", preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Post", style: .default) { _ in
      guard
        let textField = alert.textFields?.first,
        let text = textField.text else {
          return
      }
      
      let data = ["user": self.user!.displayName!,
                  "user_id": self.user!.uid,
                  "text": text,
                  "timestamp": NSDate().description]
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
  
  override func viewDidLoad() {
    let path = "chats/\(group.key)/messages/"
    print(path)
    reference = FIRDatabase.database().reference().child(path)
    self.title = group.name
    
    // Keep track of the user
    FIRAuth.auth()!.addStateDidChangeListener { auth, user in
      guard let user = user else { return }
      self.user = user
    }
    
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
