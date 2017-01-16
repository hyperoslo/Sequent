import ReactiveReSwift
import RxSwift
import Sequent
import Malibu
import When

// State

struct AppState: StateType {
  var posts: Output<[String: Any]> = .data([:])
}

// Actions

struct SetPostsAction: DynamicAction {
  var payload: Output<[String: Any]>
}

struct FetchPosts: RequestActionCreator, GETRequestable {
  typealias ActionType = SetPostsAction

  let networking: String = "base"
  var message: Message = Message(resource: "posts")

  func transform(ride: Ride) -> Promise<[String: Any]> {
    return ride.validate().toJsonDictionary()
  }
}

// Reducer

let reducer = Reducer<AppState> { action, state in
  switch action {
  case let setAction as SetPostsAction:
    return AppState(posts: setAction.payload)
  default:
    return state
  }
}

// Store

let mainStore = Store(
  reducer: reducer,
  stateType: AppState.self,
  observable: Variable(AppState())
)
