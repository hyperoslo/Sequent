import Foundation
import Compass
import RxSwift
import ReSwift

// MARK: - Route intents

public protocol RouteIntent {
  func buildAction(from location: Location) throws -> Action
}

public struct IntentRouter {
  public var routes = [String: RouteIntent]()
}

// MARK: - Navigator

public final class Navigator {

  public enum Failure: Error {
    case invalidUrlString(String)
    case invalidRoute(URL)
  }

  let navigationRouter: () -> Router
  var intentRouter: (() -> IntentRouter)?
  let currentController: () -> CurrentController
  let observable: () -> Observable<NavigationState>
  private let disposeBag = DisposeBag()

  // MARK: - Initialization

  public init(
    navigationRouter: @escaping () -> Router,
    intentRouter: (() -> IntentRouter)? = nil,
    observable: @escaping () -> Observable<NavigationState>,
    currentController: @escaping () -> CurrentController)
  {
    self.navigationRouter = navigationRouter
    self.intentRouter = intentRouter
    self.observable = observable
    self.currentController = currentController
    Compass.routes = Array(navigationRouter().routes.keys)

    if let intentRouter = intentRouter?() {
      Compass.routes += Array(intentRouter.routes.keys)
    }

    observe()
  }

  // MARK: - Action

  public func buildAction(urn: String, payload: Any? = nil) -> Action {
    let urlString = "\(Compass.scheme)\(urn)"
    return buildAction(string: urlString, payload: payload)
  }

  public func buildAction(url: URL, payload: Any? = nil) -> Action {
    let urlString = url.absoluteString
    return buildAction(string: urlString, payload: payload)
  }

  private func buildAction(string: String, payload: Any?) -> Action {
    let action: Action

    do {
      guard let url = URL(string: string) else {
        throw Failure.invalidUrlString(string)
      }

      guard let location = Compass.parse(url: url, payload: payload) else {
        throw Failure.invalidRoute(url)
      }

      if let intent = intentRouter?().routes[location.path] {
        action = try intent.buildAction(from: location)
      } else {
        action = NavigationAction(payload: Output.data(location))
      }
    } catch {
      action = NavigationAction(payload: Output.error(error))
    }

    return action
  }

  // MARK: - Navigation

  func observe() {
    observable().subscribe(onNext: { [weak self] state in
      guard let strongSelf = self else {
        return
      }

      switch state.location {
      case .data(let location):
        strongSelf.navigationRouter().navigate(to: location, from: strongSelf.currentController())
      case .error(let error):
        strongSelf.navigationRouter().errorRoute?.handle(routeError: error, from: strongSelf.currentController())
      default:
        break
      }
    }).addDisposableTo(disposeBag)
  }
}
