import Tailor

public extension SafeMappable {

  static func map(array: JsonArray) throws -> [Self] {
    return try array.map({ try Self.init($0) })
  }
}
