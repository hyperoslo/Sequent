import UIKit
import Sequent
import Spots
import RxSwift

class NotesController: Spots.Controller {

  var models: [Note] = []
  private let disposeBag = DisposeBag()

  // MARK: - Initialization

  deinit {
    // Don't forget to dispose all reaction tokens.
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Notes"
    view.backgroundColor = UIColor.white

    App.store.observable.asObservable().map({ $0.notes }).subscribe(onNext: { [weak self] posts in
      switch posts {
      case .progress:
        self?.refreshControl.beginRefreshing()
      case .data(let components):
        self?.reloadIfNeeded(components)
      case .error(let error):
        print(error)
      }
    }).addDisposableTo(disposeBag)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refreshData()
  }

  // MARK: - Actions

  func refreshData() {
    let action = FetchNotes()
    App.store.dispatch(action)
  }
}
