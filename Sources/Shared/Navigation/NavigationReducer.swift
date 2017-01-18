import ReactiveReSwift

public struct NavigationReducer {

  public func reduce(action: Action, state: NavigationState) -> NavigationState {
    var state = state

    switch action {
    case let action as NavigationAction:
      state.previousLocation = state.location
      state.location = action.payload
    default:
      break
    }

    return state
  }
}
