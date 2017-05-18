import Vapor
import Foundation

/// Dog model
final class Dog: Model {
  var exists: Bool = false
  var id: Node?
  var name: String
  var breed: String
  
  /// Custom initialization
  init(name: String, breed: String) {
    self.name = name
    self.breed = breed
  }
  
  /// Custom initialation
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    name = try node.extract("name")
    breed = try node.extract("breed")
  }
  
  /// Convert our internal class to a Node (Fluent ORM)
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "name": name,
      "breed": breed
      ])
  }
  
  /// Create database entry
  static func prepare(_ database: Database) throws {
    try database.create("dogs") { dogs in
      dogs.id()
      dogs.string("name")
      dogs.string("breed")
    }
  }
  
  /// Delete the entire database
  /// - Note: This will delete the entire db
  static func revert(_ database: Database) throws {
    try database.delete("dogs")
  }
}
