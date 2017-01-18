import Compass

public struct NavigationState: Equatable {
  public var previousLocation: Output<Location>
  public var location: Output<Location>

  public init(previousLocation: Output<Location> = .progress, location: Output<Location> = .progress) {
    self.previousLocation = previousLocation
    self.location = location
  }
}

public func ==(lhs: NavigationState, rhs: NavigationState) -> Bool {
  return lhs.previousLocation == rhs.previousLocation && lhs.location == rhs.location
}

extension Location: Equatable {}

public func ==(lhs: Location, rhs: Location) -> Bool {
  return lhs.path == rhs.path && lhs.arguments == rhs.arguments
}

