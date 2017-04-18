//: Convert data to JSON and post to a server

import Foundation
import PlaygroundSupport

// Allow playground to execute
PlaygroundPage.current.needsIndefiniteExecution = true

// You should be storing the session data as it is being
// generated by the user.  Once the session is over, you
// should convert the data to JSON and post it.

// Some fake data
let data = [
  "session" : [
    "user"  : "some_unique_identifier",
    "start" : "Apr 11, 2017, 6:17 PM",
    "end"   : "Apr 13, 2017, 6:19 PM",
    "events" : [
      [ "id" : "share-button" ],
      [ "id" : "home-button"  ],
      [ "id" : "info-button" ],
      [ "id" : "navigate-home" ],
      [ "id" : "navigate-home" ]
    ],
    "touches": [
      ["x": 10.5,"y" : 0],
      ["x": 20.1,"y" : 20],
      ["x": 30.2,"y" : 11],
      ["x": 110.6,"y" : 311],
      ["x": 0.2,"y" : 1],
      ["x": 310.9,"y" : 2]
    ]
  ]
]


// Create the url with URL
let url = URL(string: "http://localhost:8080/")!

// Create the session object
let session = URLSession.shared

// Create the URLRequest object using the url object
var request = URLRequest(url: url)

// Set http method as POST and add headers
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.addValue("application/json", forHTTPHeaderField: "Accept")

// Convert the data to JSON
do {
  let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
  request.httpBody = jsonData
} catch {
  print(error.localizedDescription)
}

//create dataTask using the session object to send data to the server
let task = session.dataTask(with: request as URLRequest,
                            completionHandler: { data, response, error in
                              // This is what should be returned by the server
                              print(response)
                              print(data)
})
task.resume()