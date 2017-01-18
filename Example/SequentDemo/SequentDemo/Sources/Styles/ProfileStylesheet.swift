import Fashion

struct ProfileStylesheet: Stylesheet {

  enum Style: String, StringConvertible {
    case notesCountLabel
    case todosCountLabel

    var string: String {
      return rawValue.styleKey(prefix: ProfileStylesheet.self)
    }
  }

  func define() {
    // Custom styles

    register(Style.notesCountLabel) { (label: UILabel) in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = UIColor.black
      label.font = UIFont.systemFont(ofSize: 16)
      label.numberOfLines = 1
    }

    register(Style.todosCountLabel) { (label: UILabel) in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = UIColor.black
      label.font = UIFont.systemFont(ofSize: 16)
      label.numberOfLines = 1
    }
  }
}
