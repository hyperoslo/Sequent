import ReactiveReSwift
import RxSwift
import Sequent
import Malibu
import When
import Spots

// State

struct AppState: StateType {
  var notes: Output<[Component]> = .data([])
}

// Store

struct App {
  static let store = Store(
    reducer: reducer,
    observable: Variable(AppState())
  )

  static let reducer = Reducer<AppState> { action, state in
    switch action {
    case let action as SetNotesAction:
      return AppState(notes: action.payload)
    default:
      return state
    }
  }
}
