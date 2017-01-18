import Compass
import Sequent

enum AppRoute: String {
  case note = "notes:{id}"
}

enum AppAction: String {
  case test = "test"
}

struct ErrorRoute: ErrorRoutable {

  func handle(routeError: Error, from currentController: CurrentController) {
    print(routeError)
  }
}

struct CompassConfigurator: Configurable {

  func configure() {
    Compass.scheme = "sequent"
    App.router.errorRoute = ErrorRoute()
    App.router.routes = [
      AppRoute.note.rawValue : NoteRoute()
    ]
  }
}
