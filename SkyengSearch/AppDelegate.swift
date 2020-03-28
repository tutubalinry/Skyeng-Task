import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    let mainCoordinator = MainCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        mainCoordinator.start()
        window?.rootViewController = mainCoordinator.rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

