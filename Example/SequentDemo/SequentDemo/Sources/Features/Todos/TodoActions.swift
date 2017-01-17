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

struct TodoListIntent: NetworkIntent, GETRequestable {
  var message: Message = Message(resource: "todos")

  func asNetworkObservable() -> NetworkObservable<TodoListAction> {
    return NetworkObservable(networking: "base", request: self) { ride in
      return ride.validate().toJsonArray().toComponents(builder: TodoItemBuilder.self, kind: .List)
    }
  }
}

// Update

struct TodoUpdateAction: DynamicAction {
  var payload: Output<Item>
}

struct TodoUpdateIntent: NetworkIntent, PATCHRequestable {
  var message: Message

  init(entity: Todo) {
    message = Message(resource: "todos/\(entity.id)")
    message.parameters = [
      "completed" : entity.completed
    ]
  }

  func asNetworkObservable() -> NetworkObservable<TodoUpdateAction> {
    return NetworkObservable(networking: "base", request: self) { ride in
      return ride.validate().toJsonDictionary().toItem(builder: TodoItemBuilder.self)
    }
  }
}
