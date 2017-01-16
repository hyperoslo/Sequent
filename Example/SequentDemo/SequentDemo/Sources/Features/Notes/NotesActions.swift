import Sequent
import Malibu
import When
import Brick
import Spots
import Tailor

// Actions

struct SetNotesAction: DynamicAction {
  var payload: Output<[Component]>
}

struct FetchNotes: RequestActionCreator, GETRequestable {
  typealias ActionType = SetNotesAction

  let networking: String = "base"
  var message: Message = Message(resource: "posts")

  func transform(ride: Ride) -> Promise<[Component]> {
    return ride
      .validate()
      .toJsonArray()
      .then({ array -> [Component] in
        let notes = try array.map({ try Note($0) })
        let items = notes.map({
          return NoteTransformer(note: $0).listItem
        })

        let component = Component(kind: Component.Kind.List.rawValue, items: items)
        return [component]
      })
  }
}

struct SetNoteAction: DynamicAction {
  var payload: Output<Item>
}

struct UpdateNote: RequestActionCreator, PATCHRequestable {
  typealias ActionType = SetNoteAction

  let networking: String = "base"
  var message: Message
  
  init(model: Note) {
    message = Message(resource: "posts/\(model.id)")
    message.parameters = [
      "title" : model.title,
      "body"  : model.body
    ]
  }

  func transform(ride: Ride) -> Promise<Item> {
    return ride
      .validate()
      .toJsonDictionary()
      .then({
        return NoteTransformer(note: try Note($0)).listItem
      })
  }
}




//struct NoteFeature: ListFeature, DetailFeature, DeleteFeature {
//  typealias Model = Note
//
//  var resource = "posts"
//
//  func render(model: Note, on cell: UITableViewCell) {
//    cell.textLabel?.text = model.title.capitalized
//    cell.detailTextLabel?.text = "Note ID: \(model.id)"
//  }
//
//  func select(model: Note, controller: UITableViewController) {
//    let detailController = NoteDetailController(id: model.id)
//    controller.navigationController?.pushViewController(detailController, animated: true)
//  }
//}
//
//// MARK: - Update
//
//extension NoteFeature: UpdateFeature {
//
//  struct Request: PATCHRequestable {
//    var message: Message
//
//    init(model: Note) {
//      message = Message(resource: "posts/\(model.id)")
//      message.parameters = [
//        "title" : model.title,
//        "body"  : model.body
//      ]
//    }
//  }
//
//  func buildUpdateRequest(from model: Model) -> PATCHRequestable {
//    return Request(model: model)
//  }
//}

// MARK: - List, Delete

//struct TodoFeature: ListFeature, DeleteFeature, CommandProducer {
//  typealias Model = Todo
//
//  var resource = "todos"
//
//  func render(model: Todo, on cell: UITableViewCell) {
//    cell.textLabel?.text = model.title.capitalized
//    cell.accessoryType = model.completed ? .checkmark : .none
//  }
//
//  func select(model: Todo, controller: UITableViewController) {
//    var model = model
//    model.completed = !model.completed
//
//    execute(command: UpdateCommand<TodoFeature>(model: model))
//  }
//}
//
//// MARK: - Update
//
//extension TodoFeature: UpdateFeature {
//
//  struct UpdateRequest: PATCHRequestable {
//    var message: Message
//
//    init(model: Todo) {
//      message = Message(resource: "todos/\(model.id)")
//      message.parameters = [
//        "completed" : model.completed
//      ]
//    }
//  }
//
//  func buildUpdateRequest(from model: Model) -> PATCHRequestable {
//    return UpdateRequest(model: model)
//  }
//}
