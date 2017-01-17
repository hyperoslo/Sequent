import Brick
import Sequent

struct NoteItemBuilder: ItemBuilder {

  let note: Note

  init(_ entity: Note) {
    self.note = entity
  }

  func build() -> Item {
    return Item(
      identifier: note.id,
      title: note.title,
      subtitle: "Author: \(note.userId)",
      text: note.body,
      kind: "list",
      action: "notes:\(note.id)")
  }
}
