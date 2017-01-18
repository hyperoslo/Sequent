import UIKit
import Sequent
import RxSwift

class ProfileController: UIViewController {

  lazy var notesCountLabel: UILabel = UILabel(styles: ProfileStylesheet.Style.notesCountLabel)
  lazy var todosCountLabel: UILabel = UILabel(styles: ProfileStylesheet.Style.todosCountLabel)
  private let disposeBag = DisposeBag()

  // MARK: - Initialization

  deinit {
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.stylize(MainStylesheet.Style.content)

    [notesCountLabel, todosCountLabel].forEach {
      self.view.addSubview($0)
    }

    App.store.observable.asObservable().map({ $0.profile }).subscribe(onNext: { [weak self] profile in
      self?.notesCountLabel.text = "Total notes: \(profile.notesCount)"
      self?.todosCountLabel.text = "Total todos: \(profile.todosCount)"
    }).addDisposableTo(disposeBag)

    setupConstrains()
  }

  // MARK: - Layout

  func setupConstrains() {
    notesCountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 84).isActive = true
    notesCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    notesCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

    todosCountLabel.topAnchor.constraint(equalTo: notesCountLabel.bottomAnchor, constant: 20).isActive = true
    todosCountLabel.leadingAnchor.constraint(equalTo: notesCountLabel.leadingAnchor).isActive = true
    todosCountLabel.trailingAnchor.constraint(equalTo: notesCountLabel.trailingAnchor).isActive = true
  }
}
