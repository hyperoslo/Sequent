import ReactiveReSwift
import RxSwift
import Sequent
import Malibu
import When
import Spots

// State

struct AppState: StateType {
  var notes: Output<Component> = .data(Component())
}

// Store

struct App {
  static let store = Store(
    reducer: reducer,
    observable: Variable(AppState()),
    middleware: Middleware(loggingMiddleware)
  )

  static let loggingMiddleware = Middleware<AppState>().sideEffect { getState, dispatch, action in
    // perform middleware logic
    print(String(reflecting: type(of:action)))
  }

  static let reducer = Reducer<AppState> { action, state in
    switch action {
    case let action as NoteListAction:
      return AppState(notes: action.payload)
    default:
      return state
    }
  }
}
