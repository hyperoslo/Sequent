import UIKit
import Sequent
import RxSwift
import ReactiveReSwift

class ViewController: UIViewController {

  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white

    let action = FetchPosts()

    // [weak self]
    mainStore.observable.asObservable().map({ $0.posts }).subscribe(onNext: { posts in
      switch posts {
      case .progress:
        break
      case .data(let components):
        print(components)
        break
      case .error(let error):
        print(error)
        break
      }
    }).addDisposableTo(disposeBag)

    mainStore.dispatch(action)
  }
}

