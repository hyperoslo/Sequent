import Brick
import Tailor

public protocol ItemBuilder {
  associatedtype T: SafeMappable
  init(_ entity: T)
  func build() -> Item
}
