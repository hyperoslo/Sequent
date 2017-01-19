import XCTest
import Sequent
import ReSwift
import RxSwift

class SubscriberTests: XCTestCase {

  struct State: StateType {
    let value: Int
  }

  struct IncreaseAction: Action {

  }

  struct Reducer: ReSwift.Reducer {

    func handleAction(action: Action, state: State?) -> State {
      if action is IncreaseAction, let state = state {
        return State(value: state.value + 1)
      } else {
        return State(value: 0)
      }
    }
  }

  func testSubscriber() {
    let store = Store(reducer: Reducer(), state: State(value: 0))
    let subscriber = Subscriber(store: store)

    var index: Int = 0
    var expectedValues: [Int] = [0, 1, 2]

    let _ = subscriber.state.asObservable().subscribe { (event) in
      switch event {
      case .next(let state):
        if let state = state {
          XCTAssertEqual(state.value, expectedValues[index])
          index += 1
        } else {
          XCTFail()
        }
      default:
        break
      }
    }

    store.dispatch(IncreaseAction())
    store.dispatch(IncreaseAction())
  }
}
