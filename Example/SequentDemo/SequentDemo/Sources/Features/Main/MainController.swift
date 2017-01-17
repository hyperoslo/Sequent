import UIKit
import Sequent

class MainController: UITabBarController {

  lazy var noteListController: UINavigationController = {
    let controller = SequentController(
      cacheKey: "notes",
      dispatch: ({
        App.store.dispatch(NoteListIntent())
      }),
      observable: ({
        return App.store.observable.asObservable().map({ $0.notes })
      })
    )

    let navigationController = UINavigationController(rootViewController: controller)
    controller.view.backgroundColor = UIColor.white
    controller.view.stylize(MainStylesheet.Style.content)
    controller.title = "Notes"
    controller.tabBarItem.title = "Notes"
    controller.tabBarItem.image = UIImage(named: "tabNotes")

    return navigationController
  }()

  lazy var todoListController: UINavigationController = {
    let controller = SequentController(
      cacheKey: "notes",
      dispatch: ({
        App.store.dispatch(TodoListIntent())
      }),
      observable: ({
        return App.store.observable.asObservable().map({ $0.todos })
      })
    )

    let navigationController = UINavigationController(rootViewController: controller)
    controller.view.backgroundColor = UIColor.white
    controller.tabBarItem.title = "Todos"
    controller.title = "Todos"
    controller.tabBarItem.image = UIImage(named: "tabTodos")

    return navigationController
  }()

  lazy var profileController: UINavigationController = {
    let controller = ProfileController()
    let navigationController = UINavigationController(rootViewController: controller)
    controller.tabBarItem.title = "Profile"
    controller.title = "Profile"
    controller.tabBarItem.image = UIImage(named: "tabProfile")

    return navigationController
  }()

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Sequent"
    view.stylize(MainStylesheet.Style.content)
    configureTabBar()
  }

  // MARK: - Configuration

  func configureTabBar() {
    viewControllers = [
      noteListController,
      todoListController,
      profileController
    ]
    
    selectedIndex = 0
  }
}
