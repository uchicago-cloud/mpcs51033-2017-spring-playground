import Vapor
import VaporPostgreSQL

/// Instance of the Vapor app
let drop = Droplet()

// Add the Dog class to the drop
drop.preparations.append(Dog.self)

// Add PostgreSql provider
do {
  try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
  assertionFailure("Error adding provider: \(error)")
}

//
// MARK: - Create 
//


// Create some `Dog` objects and transform them to 
// nodes.  In this case, we are just dumping them 
// out as JSON in the repsone (not saving them).
drop.get("dog","create") { req in
  let dog = [Dog(name:"Lulu", breed: "Boston Terrier"),
             Dog(name:"Snoopy", breed: "Beagle"),
             Dog(name:"Fifi", breed: "Poodle")]
  let dogNode = try dog.makeNode()
  let nodeDictionary = ["dogs": dogNode]
  return try JSON(node: nodeDictionary)
}

// Add a dog (save) to the database
drop.get("dog","add", String.self) { req, name in
  var dog = Dog(name: name, breed: "Pitbull")
  try dog.save()
  return try JSON(node: Dog.all().makeNode())
}


//
// MARK: - Update
//

// Get the first dog and change its breed to a poodle
drop.get("update-poodle") { req in
  guard var dog = try Dog.query().first() else {
    throw Abort.badRequest
  }
  dog.breed = "Poodle"
  try dog.save()
  return dog
}


//
// MARK: - Queries
//


// List all dogs
drop.get("dog","pound") { req in
  return try JSON(node: Dog.all().makeNode())
}

// Get all bostons
drop.get("query-boston") { req in
  return try JSON(node: Dog.query().filter("breed", .equals, "Boston Terrier").all().makeNode())
}


//
// MARK: - Routes
//


// Route to print out the db version
drop.get("version") { req in
  if let db = drop.database?.driver as? PostgreSQLDriver {
    let version = try db.raw("SELECT version()")
    return try JSON(node: version)
  } else {
    return "No database connection"
  }
}

drop.get { req in
  return try JSON(node:
    ["message": "Hello Vapor"]
  )
}

drop.get("dog") { req in
  return "Woof woof"
}

drop.get("dog","speak") { req in
  return "Bark! Bark!"
}

drop.get("dog","speak",Int.self) { req, number in
  return "My favorite number is \(number)"
}

// Run the app
drop.run()

