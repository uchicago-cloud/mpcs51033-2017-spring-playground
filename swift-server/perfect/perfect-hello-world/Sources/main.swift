import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer ()
server.serverPort = 8088
server.documentRoot = "webroot"


var routes = Routes()

// Route "/"
routes.add(method: .get, uri: "/", handler: {
  request, response in
  response.setBody(string: "Hello Perfect World!! 3")
  response.completed()
})

// Route "/dogs/speak/"
routes.add(method: .get, uri: "/dog/speak/", handler: {
  request, response in
  response.setBody(string: "Bark!")
  response.completed()
})

// Route "/dogs/{name}/"
routes.add(method: .get, uri: "/dog/speak/{name}/", handler: {
  request, response in
  guard let name = request.urlVariables["name"],
    let nameString = String(name) else {
      response.completed(status: .badRequest)
      return
  }
  response.setBody(string: "\(nameString) says Bark!")
  response.completed()
})

server.addRoutes(routes)


// Start the server
do {
  try server.start()
} catch PerfectError.networkError(let err, let msg) {
  print("Network Error: \(err) \(msg)")
}
