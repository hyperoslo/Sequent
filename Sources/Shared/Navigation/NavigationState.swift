import Compass

public struct NavigationState {
  public var previousLocation: Output<Location> = .progress
  public var location: Output<Location> = .progress
}
