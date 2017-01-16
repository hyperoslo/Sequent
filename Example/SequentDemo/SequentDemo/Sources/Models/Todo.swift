import Tailor
import Sequent

struct Todo: Entity {
  let id: Int
  let userId: Int
  let title: String
  var completed: Bool

  init(_ map: JsonDictionary) throws {
    id = try <-map.property("id")
    userId = try <-map.property("userId")
    title = try <-map.property("title")
    completed = try <-map.property("completed")
  }
}
