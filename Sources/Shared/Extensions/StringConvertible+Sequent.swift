import Brick

public extension StringConvertible where Self: RawRepresentable, Self.RawValue == String {

  var string: String {
    return rawValue.dashed()
  }
}
