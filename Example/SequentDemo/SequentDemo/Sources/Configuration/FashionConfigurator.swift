import Sequent
import Fashion

public struct FashionConfigurator: Configurable {

  public func configure() {
    let stylesheets: [Stylesheet] = [
      MainStylesheet(),
      NoteStylesheet(),
      ProfileStylesheet()
    ]

    Fashion.register(stylesheets: stylesheets)
  }
}
