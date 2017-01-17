import UIKit
import Spots
import Brick
import RxSwift
import ReactiveReSwift

public class SequentController: Spots.Controller {

  public enum RefreshMode {
    case always, onlyWhenEmpty, disabled
  }

  public enum Feature {
    case pullToRefresh

    static let allValues = [pullToRefresh]
  }

  var behaviors = [Behavior]()

  var dispatch: (() -> Void)?
  public var refreshMode: RefreshMode = .disabled
  public var refreshOnViewDidAppear: Bool = true
  public var enabledFeatures: [Feature] = [.pullToRefresh] {
    didSet { toggle(features: enabledFeatures) }
  }

  public var viewModelComparison = { (lhs: [Component], rhs: [Component]) in
    lhs !== rhs
  }

  public var errorHandler: ((_ error: Error) -> Void)?

  // MARK: - Initialization
  public required init(
    cacheKey: String? = nil,
    spots: [Spotable] = [],
    dispatch: (() -> Void)? = nil,
    behaviors: [Behavior] = [],
    features: [Feature] = Feature.allValues)
  {
    var stateCache: StateCache? = nil
    var cachedSpots: [Spotable] = spots

    if let cacheKey = cacheKey {
      stateCache = StateCache(key: cacheKey)
      cachedSpots = Parser.parse(stateCache!.load())
    }

    self.dispatch = dispatch
    self.behaviors = behaviors
    super.init()
    self.stateCache = stateCache
    self.spots = cachedSpots
    self.enabledFeatures = features

    for behavior in behaviors {
      behavior.extend(controller: self)
    }
  }

  public convenience init<T: ObservableType>(
    cacheKey: String? = nil,
    spots: [Spotable] = [],
    dispatch: (() -> Void)? = nil,
    observable: @escaping () -> T,
    behaviors: [Behavior] = [],
    features: [Feature] = Feature.allValues) where T.E == Output<[Component]>
  {
    self.init(cacheKey: cacheKey, spots: spots, dispatch: dispatch, behaviors: behaviors, features: features)
    let reloadBehavior = ComponentReloadBehavior(observable: observable)
    reloadBehavior.extend(controller: self)
    self.behaviors.append(reloadBehavior)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public required init(spots: [Spotable]) {
    fatalError("init(spots:) has not been implemented")
  }

  deinit {
  }

  // MARK: - View Lifecycle
  open override func viewDidLoad() {
    super.viewDidLoad()
    toggle(features: enabledFeatures)
  }

  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    dispatch?()

    for case let behavior as PreAppearingBehavior in behaviors {
      behavior.behaviorWillAppear(in: self)
    }
  }

  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    for case let behavior as PostAppearingBehavior in behaviors {
      behavior.behaviorDidAppear(in: self)
    }
  }

  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    for case let behavior as PreDisappearingBehavior in behaviors {
      behavior.behaviorWillDisappear(in: self)
    }
  }

  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    for case let behavior as PostDisappearingBehavior in behaviors {
      behavior.behaviorDidDisappear(in: self)
    }
  }

  func toggle(features: [Feature]) {
    for feature in Feature.allValues {
      switch feature {
      case .pullToRefresh:
        refreshDelegate = features.contains(feature) ? self : nil
      }
    }
  }
}

extension SequentController: Spots.RefreshDelegate {

  public func spotsDidReload(_ refreshControl: UIRefreshControl, completion: Completion) {
    dispatch?()
    completion?()
  }
}
