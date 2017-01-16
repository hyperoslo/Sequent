import Spots
import Brick
import Malibu
import When
import Tailor

public protocol ResponseTransformer {
  associatedtype T
  func transform(ride: Ride) -> Promise<T>
}

public struct ViewModelTransformer: ResponseTransformer {

  public let viewModel: ViewModel.Type

  public func transform(ride: Ride) -> Promise<[Component]> {
    return ride
      .validate()
      .toJsonDictionary()
      .then({ json -> [Component] in
        let components = try self.viewModel.init(json).components
        return components
      })
  }
}
