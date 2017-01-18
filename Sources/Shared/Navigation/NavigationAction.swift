import Compass

public struct NavigationAction: DynamicAction {
  public let payload: Output<Location>

  public init(payload: Output<Location>) {
    self.payload = payload
  }
}
