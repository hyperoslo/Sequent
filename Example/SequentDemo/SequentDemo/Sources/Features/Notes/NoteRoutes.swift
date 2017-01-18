import Compass

struct NoteRoute: Routable {

  func navigate(to location: Location, from currentController: CurrentController) throws {
    let controller = NoteController(id: 0)
    currentController.navigationController?.pushViewController(controller, animated: true)
  }
}
