import Foundation
import ReSwift

public protocol DynamicAction: Action {
  associatedtype Data
  var payload: Output<Data> { get }
  init(payload: Output<Data>)
}
