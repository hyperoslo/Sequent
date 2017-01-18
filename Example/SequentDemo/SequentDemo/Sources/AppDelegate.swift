import UIKit
import Sequent

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  var configurators: [Configurable] = [
    FashionConfigurator(),
    MalibuConfigurator(),
    SpotsConfigurator(),
    CompassConfigurator()
  ]

  lazy var mainController: MainController = {
    let controller = MainController()
    return controller
  }()

  var navigator: Navigator?

  // MARK: - Application lifecycle

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = mainController

    App.delegate = self

    configurators.forEach {
      $0.configure()
    }

    //.scan(App.store.observable.value.navigationState) { lastValue, newValue in
    //  return Array(lastSlice + [newValue]).suffix(3)

    navigator = Navigator(
      navigationRouter: { App.router },
      observable: {
        App.store.observable.asObservable().map({ $0.navigationState }).distinctUntilChanged()
      },
      currentController: {
        (self.mainController.selectedViewController as? UINavigationController)!.topViewController!
      }
    )

    window?.makeKeyAndVisible()

    return true
  }
}
