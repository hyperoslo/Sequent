import ReactiveReSwift
import RxSwift
import Compass
import Foundation

public enum CompassError: Error {
  case invalidUrlString(String)
  case invalidRoute(URL)
}

//public struct CompassIntent: Intent {
//  public typealias E = CompassAction
//
//  public let urlString: String
//  public let payload: Any?
//
//  // MARK: - Initialization
//
//  public init(urn: String, payload: Any? = nil) {
//    self.urlString = "\(Compass.scheme)\(urn)"
//    self.payload = payload
//  }
//
//  public init(url: URL, payload: Any? = nil) {
//    self.urlString = url.absoluteString
//    self.payload = payload
//  }
//
//  func buildAction(payload: Output<Location>) -> CompassAction {
//    return CompassAction(payload: payload)
//  }
//
//  func buildPayload() -> Output<Location> {
//    let payload: Output<Location>
//
//    do {
//      guard let url = URL(string: urlString) else {
//        throw CompassError.invalidUrlString(urlString)
//      }
//
//      guard let location = Compass.parse(url: url, payload: payload) else {
//        throw CompassError.invalidRoute(url)
//      }
//
//      payload = .data(location)
//    } catch {
//      payload = .error(error)
//    }
//
//    return payload
//  }
//
//  func asObservable() -> Observable<E> {
//    let action = buildAction(payload: buildPayload())
//    return Observable<CompassAction>.
//  }
//}
//
//public struct CompassAction: DynamicAction {
//  var payload: Output<Location>
//}
