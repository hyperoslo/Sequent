import RxSwift
import Spots

public final class ComponentReloadBehavior: Behavior {

  weak var controller: SequentController?
  let observable: () -> Observable<Output<[Component]>>
  private let disposeBag = DisposeBag()

  public init(observable: @escaping () -> Observable<Output<[Component]>>) {
    self.observable = observable
  }

  fileprivate func stopReloading() {
    if self.controller?.refreshControl.isRefreshing == true {
      DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: {
          self.controller?.refreshControl.endRefreshing()
      }
      )
    }
  }

  public func extend(controller: SequentController) {
    self.controller = controller

    observable().subscribe(onNext: { [weak self] value in
      switch value {
      case .progress:
        guard self?.controller?.refreshMode != .disabled else { return }

        if self?.controller?.refreshMode == .always {
          self?.controller?.refreshControl.beginRefreshing()
        } else if self?.controller?.refreshMode == .onlyWhenEmpty &&
          self?.controller?.spots.isEmpty == true {
          self?.controller?.refreshControl.beginRefreshing()
        }
      case .data(let components):
        guard let controller = self?.controller, controller.refreshOnViewDidAppear else { return }

        controller.reloadIfNeeded(components, compare: controller.viewModelComparison) {
          Spots.Controller.spotsDidReloadComponents?(controller)
        }
        self?.stopReloading()
      case .error(let error):
        self?.controller?.errorHandler?(error)
        self?.stopReloading()
      }
    }).addDisposableTo(disposeBag)
  }
}
