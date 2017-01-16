import Brick

struct NoteTransformer {

  let note: Note

  var listItem: Item {
    return Item(
      identifier: note.id,
      title: note.title,
      subtitle: "Author: \(note.userId)",
      text: note.body,
      kind: "list",
      action: "notes:\(note.id)")
  }
}
