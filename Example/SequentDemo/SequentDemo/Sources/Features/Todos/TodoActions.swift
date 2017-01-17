import Sequent
import Malibu
import When
import Brick
import Spots
import Tailor

// List

struct TodoListAction: DynamicAction {
  var payload: Output<[Component]>
}

struct TodoListIntent: RequestIntent, GETRequestable, ComponentTransformer {
  typealias E = TodoListAction
  typealias IB = TodoItemBuilder

  let networking: String = "base"
  var message: Message = Message(resource: "todos")
  var kind: Component.Kind = .List
}

// Update

struct TodoUpdateAction: DynamicAction {
  var payload: Output<Item>
}

struct TodoUpdateIntent: RequestIntent, PATCHRequestable, ItemTransformer {
  typealias E = TodoUpdateAction
  typealias IB = TodoItemBuilder

  let networking: String = "base"
  var message: Message

  init(entity: Todo) {
    message = Message(resource: "todos/\(entity.id)")
    message.parameters = [
      "completed" : entity.completed
    ]
  }
}
