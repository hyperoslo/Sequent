import Tailor
import Spots

public protocol ViewModel: SafeMappable {
  var components: [Component] { get }
}

public protocol ComponentModel {
  var component: Component { get }
  init(_ array: JsonArray) throws
}
