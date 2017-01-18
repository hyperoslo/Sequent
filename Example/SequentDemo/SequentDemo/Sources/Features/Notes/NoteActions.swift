import Sequent
import Malibu
import When
import Brick
import Spots
import Tailor
import RxSwift
import ReactiveReSwift

// List

struct NoteListAction: DynamicAction {
  var payload: Output<[Component]>
}

struct NoteListIntent: NetworkIntent, GETRequestable {
  var message: Message = Message(resource: "posts")

  func asNetworkObservable() -> NetworkObservable<NoteListAction> {
    return NetworkObservable(networking: "base", request: self) { ride in
      return ride.validate().toJsonArray().toComponents(builder: NoteItemBuilder.self, kind: .List)
    }
  }
}

// Update

struct NoteUpdateAction: DynamicAction {
  var payload: Output<Item>
}

struct NoteUpdateIntent: NetworkIntent, PATCHRequestable {
  var message: Message

  init(model: Note) {
    message = Message(resource: "posts/\(model.id)")
    message.parameters = [
      "title" : model.title,
      "body"  : model.body
    ]
  }

  func asNetworkObservable() -> NetworkObservable<NoteUpdateAction> {
    return NetworkObservable(networking: "base", request: self) { ride in
      return ride.validate().toJsonDictionary().toItem(builder: NoteItemBuilder.self)
    }
  }
}

// Detail

struct NoteAction: DynamicAction {
  var payload: Output<Item>
}

struct NoteIntent: NetworkIntent, GETRequestable {
  var message: Message

  init(model: Note) {
    message = Message(resource: "posts/\(model.id)")
  }

  func asNetworkObservable() -> NetworkObservable<NoteAction> {
    return NetworkObservable(networking: "base", request: self) { ride in
      return ride.validate().toJsonDictionary().toItem(builder: NoteItemBuilder.self)
    }
  }
}
