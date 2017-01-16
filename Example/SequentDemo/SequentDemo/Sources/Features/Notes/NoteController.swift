import UIKit
import Sequent

class NoteController: UIViewController {

  let id: Int
  var loaded = false

  var note: Note? {
    didSet {
      guard let note = note else {
        return
      }

      titleLabel.text = note.title.capitalized
      textView.text = note.body
    }
  }

  lazy var saveButton: UIBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .save,
    target: self,
    action: #selector(saveButtonDidPress))

  lazy var titleLabel: UILabel = UILabel(styles: NoteStylesheet.Style.DetailTitleLabel)
  lazy var textView: UITextView = UITextView(styles: NoteStylesheet.Style.DetailTextView)

  // MARK: - Initialization

  required init(id: Int) {
    self.id = id
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    // Don't forget to dispose all reaction tokens.
    //disposeAll()
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Note"
    view.stylize(MainStylesheet.Style.content)
    navigationItem.rightBarButtonItem = saveButton

    [titleLabel, textView].forEach {
      self.view.addSubview($0)
    }

    setupConstrains()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // MARK: - Layout

  func setupConstrains() {
    titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 84).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

    textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
    textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
  }

  // MARK: - Actions

  func saveButtonDidPress() {
    guard var note = note, let title = titleLabel.text, let body = textView.text else {
      return
    }

    note.title = title
    note.body = body
  }
}
