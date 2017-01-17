import When
import RxSwift
import Spots
import Brick

extension Promise: ObservableConvertibleType {

  public func asObservable() -> Observable<T> {
    return Observable.create({ observer in
      self
        .done({ value in
          observer.onNext(value)
        })
        .fail({ error in
          observer.onError(error)
        })
        .always({ _ in
          observer.onCompleted()
        })

      return Disposables.create()
    })
  }
}

// View model

extension Collection where Self: DictionaryLiteralConvertible, Self.Key == String, Self.Value: Any, Iterator.Element == (key: Self.Key, value: Self.Value) {

  func toDictionary() -> JsonDictionary {
    var dict = JsonDictionary()

    for item in self.enumerated() {
      dict.updateValue(item.element.1, forKey: item.element.0)
    }

    return dict
  }
}

public extension Promise where T: Collection, T: DictionaryLiteralConvertible, T.Key == String, T.Value: Any, T.Iterator.Element == (key: T.Key, value: T.Value) {

  public func toComponents(viewModel: ViewModel.Type) -> Promise<[Component]> {
    return then({ collection -> [Component] in
      var dict = collection.toDictionary()
      let components = try viewModel.init(dict).components
      return components
    })
  }

  public func toItem<IB: ItemBuilder>(builder: IB.Type) -> Promise<Item> {
    return then({ collection -> Item in
      var dict = collection.toDictionary()
      return IB(try IB.T(dict)).build()
    })
  }
}

// Components

public extension Promise where T: Sequence, T.Iterator.Element == JsonDictionary {

  public func toComponents<IB: ItemBuilder>(builder: IB.Type, kind: Component.Kind) -> Promise<[Component]> {
    return then({ sequence -> [Component] in
      let array = Array(sequence)

      let items = try IB.T.map(array: array).map({
        return IB(try $0).build()
      })

      let component = Component(kind: kind.rawValue, items: items)
      return [component]
    })
  }
}
