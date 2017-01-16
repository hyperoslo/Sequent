import Sequent
import Malibu
import When
import Brick
import Spots
import Tailor

// List

struct NoteListAction: DynamicAction {
  var payload: Output<Component>
}

struct NoteListIntent: RequestIntent, GETRequestable, ComponentTransformer {
  typealias E = NoteListAction
  typealias IB = NoteItemBuilder

  let networking: String = "base"
  var message: Message = Message(resource: "posts")
  var kind: Component.Kind = .List
}

// Update

struct NoteUpdateAction: DynamicAction {
  var payload: Output<Item>
}

struct NoteUpdateIntent: RequestIntent, PATCHRequestable, ItemTransformer {
  typealias E = NoteUpdateAction
  typealias IB = NoteItemBuilder

  let networking: String = "base"
  var message: Message

  init(model: Note) {
    message = Message(resource: "posts/\(model.id)")
    message.parameters = [
      "title" : model.title,
      "body"  : model.body
    ]
  }
}

// Detail

struct NoteAction: DynamicAction {
  var payload: Output<Item>
}

struct NoteIntent: RequestIntent, GETRequestable, ItemTransformer {
  typealias E = NoteAction
  typealias IB = NoteItemBuilder

  let networking: String = "base"
  var message: Message

  init(model: Note) {
    message = Message(resource: "posts/\(model.id)")
  }
}





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
