import Sequent
import Malibu
import When
import Brick
import Spots
import Tailor

// List

struct NoteListAction: DynamicAction {
  var payload: Output<[Component]>
}

struct NoteListIntent: RequestIntent, GETRequestable, ComponentTransformer {
  typealias E = NoteListAction
  typealias IB = NoteItemBuilder

  let networking: String = "base"
  var message: Message = Message(resource: "posts")
  var kind: Component.Kind = .List
}

//struct NoteObjectListAction: DynamicAction {
//  var payload: Output<[Note]>
//}
//
//struct NoteObjectListIntent: RequestIntent, GETRequestable, EntityArrayTransformer {
//  typealias E = NoteObjectListAction
//  typealias Entity = Note
//
//  let networking: String = "base"
//  var message: Message = Message(resource: "posts")
//  var kind: Component.Kind = .List
//}

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
