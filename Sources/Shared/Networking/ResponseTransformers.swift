import Spots
import Brick
import Malibu
import When
import Tailor

public protocol ResponseTransformer {
  associatedtype T
  func transform(ride: Ride) -> Promise<T>
}

// MARK: - View Model

public protocol ViewModelTransformer: ResponseTransformer {
  associatedtype T = [Component]
  associatedtype VM: ViewModel
}

public extension ViewModelTransformer {

  func transform(ride: Ride) -> Promise<[Component]> {
    return ride
      .validate()
      .toJsonDictionary()
      .then({ json -> [Component] in
        let components = try VM.init(json).components
        return components
      })
  }
}

// MARK: - Component

public protocol ComponentTransformer: ResponseTransformer {
  associatedtype T = Component
  associatedtype IB: ItemBuilder

  var kind: Component.Kind { get }
}

public extension ComponentTransformer {

  func transform(ride: Ride) -> Promise<Component> {
    return ride
      .validate()
      .toJsonArray()
      .then({ array -> Component in
        let items = try IB.T.map(array: array).map({
          return IB(try $0).build()
        })

        return Component(kind: self.kind.rawValue, items: items)
      })
  }
}

// MARK: - Item

public protocol ItemBuilder {
  associatedtype T: SafeMappable
  init(_ entity: T)
  func build() -> Item
}

public protocol ItemTransformer: ResponseTransformer {
  associatedtype T = Item
  associatedtype IB: ItemBuilder
}

public extension ItemTransformer {

  func transform(ride: Ride) -> Promise<Item> {
    return ride
      .validate()
      .toJsonDictionary()
      .then({
        return IB(try IB.T($0)).build()
      })
  }
}
