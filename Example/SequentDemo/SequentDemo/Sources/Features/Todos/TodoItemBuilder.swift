import Brick
import Sequent

struct TodoItemBuilder: ItemBuilder {

  let note: Todo

  init(_ entity: Todo) {
    self.note = entity
  }

  func build() -> Item {
    return Item(
      identifier: note.id,
      title: note.title,
      kind: "list",
      action: "todos:\(note.id)",
      meta: ["completed": note.completed]
    )
  }
}
