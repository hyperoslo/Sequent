import Spots
import Brick
import Malibu
import When
import Tailor


// MARK: - View Model



// MARK: - Component



// MARK: - Item

public protocol ItemBuilder {
  associatedtype T: SafeMappable
  init(_ entity: T)
  func build() -> Item
}


