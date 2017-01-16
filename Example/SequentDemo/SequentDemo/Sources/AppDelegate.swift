import UIKit
import Sequent

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  var configurators: [Configurable] = [
    FashionConfigurator(),
    MalibuConfigurator(),
    SpotsConfigurator()
  ]

  lazy var mainController: MainController = {
    let controller = MainController()
    return controller
  }()

  // MARK: - Application lifecycle

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = mainController

    configurators.forEach {
      $0.configure()
    }

    window?.makeKeyAndVisible()

    return true
  }
}
