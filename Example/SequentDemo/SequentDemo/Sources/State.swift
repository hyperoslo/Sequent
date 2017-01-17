import ReactiveReSwift
import RxSwift
import Sequent
import Malibu
import When
import Spots

// State

struct AppState: StateType {
  var notes: Output<[Component]> = .data([])
  var todos: Output<[Component]> = .data([])
  var profile = Profile()
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
    var state = state

    switch action {
    case let action as NoteListAction:
      state.notes = action.payload
      if let notesCount = state.notes.data?.first?.items.count {
        state.profile.notesCount = notesCount
      }
    case let action as TodoListAction:
      state.todos = action.payload
      if let todosCount = state.todos.data?.first?.items.count {
        state.profile.todosCount = todosCount
      }
    default:
      break
    }

    return state
  }
}
