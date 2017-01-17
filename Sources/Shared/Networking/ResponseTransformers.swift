import Spots
import Brick
import Malibu
import When
import Tailor

// MARK: - Validator

public struct ResponseValidator: Validating {

  public func validate(_ result: Wave) throws {
    try StatusCodeValidator(statusCodes: 200..<300)
    let contentTypes: [String]

    if let accept = result.request.value(forHTTPHeaderField: "Accept") {
      contentTypes = accept.components(separatedBy: ",")
    } else {
      contentTypes = ["*/*"]
    }

    try ContentTypeValidator(contentTypes: contentTypes).validate(result)
  }
}

// MARK: - Transformer

public protocol ResponseTransformer {
  associatedtype T
  func transform(ride: Ride) -> Promise<T>
  var validator: Validating { get }
}

public extension ResponseTransformer {

  var validator: Validating {
    return ResponseValidator()
  }
}

// MARK: - JsonDictionary

public protocol JsonDictionaryTransformer: ResponseTransformer {
  associatedtype T = JsonDictionary
}

public extension JsonDictionaryTransformer {

  func transform(ride: Ride) -> Promise<JsonDictionary> {
    return ride
      .validate(using: validator)
      .toJsonDictionary()
  }
}

// MARK: - JsonArray

public protocol JsonArrayTransformer: ResponseTransformer {
  associatedtype T = JsonArray
}

public extension JsonArrayTransformer {

  func transform(ride: Ride) -> Promise<JsonArray> {
    return ride
      .validate(using: validator)
      .toJsonArray()
  }
}

// MARK: - View Model

public protocol ViewModelTransformer: ResponseTransformer {
  associatedtype T = [Component]
  associatedtype VM: ViewModel
}

public extension ViewModelTransformer {

  func transform(ride: Ride) -> Promise<[Component]> {
    return ride
      .validate(using: validator)
      .toJsonDictionary()
      .then({ json -> [Component] in
        let components = try VM.init(json).components
        return components
      })
  }
}

// MARK: - Component

public protocol ComponentTransformer: ResponseTransformer {
  associatedtype T = [Component]
  associatedtype IB: ItemBuilder

  var kind: Component.Kind { get }
}

public extension ComponentTransformer {

  func transform(ride: Ride) -> Promise<[Component]> {
    return ride
      .validate(using: validator)
      .toJsonArray()
      .then({ array -> [Component] in
        let items = try IB.T.map(array: array).map({
          return IB(try $0).build()
        })

        let component = Component(kind: self.kind.rawValue, items: items)
        return [component]
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
      .validate(using: validator)
      .toJsonDictionary()
      .then({
        return IB(try IB.T($0)).build()
      })
  }
}

// MARK: - Entity

public protocol EntityTransformer: ResponseTransformer {
  associatedtype Entity: SafeMappable
  associatedtype T = Entity
}

public extension EntityTransformer {

  func transform(ride: Ride) -> Promise<Entity> {
    return ride
      .validate(using: validator)
      .toJsonDictionary()
      .then({
        return try Entity($0)
      })
  }
}

// MARK: - Entity array

public protocol EntityArrayTransformer: ResponseTransformer {
  associatedtype Entity: SafeMappable
  associatedtype T = [Entity]
}

public extension EntityArrayTransformer {

  func transform(ride: Ride) -> Promise<[Entity]> {
    return ride
      .validate(using: validator)
      .toJsonArray()
      .then({
        try Entity.map(array: $0)
      })
  }
}
