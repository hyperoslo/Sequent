import ReSwift
import RxSwift

public class Subscriber<T: StateType>: StoreSubscriber {
  public typealias StoreSubscriberStateType = T

  weak var store: Store<T>?
  public let state: Variable<T>

  public init(store: Store<T>, state: T) {
    self.store = store
    self.state = Variable(state)
    store.subscribe(self)
  }

  deinit {
    store?.unsubscribe(self)
  }

  // MARK: - StoreSubscriber

  public func newState(state: Subscriber.StoreSubscriberStateType) {
    self.state.value = state
  }
}
