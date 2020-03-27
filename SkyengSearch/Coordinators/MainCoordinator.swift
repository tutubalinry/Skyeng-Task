import UIKit

protocol MainCoordinatorProtocol: class {
    
    func showDetails()
    
}

class MainCoordinator: Coordinator {
    
    private let navigationController: UINavigationController = {
        let controller = UINavigationController()
        return controller
    }()
    
    var rootViewController: UIViewController {
        navigationController
    }
    
    func start() {
        let searchController = SearchViewController()
        searchController.reactor = SearchReactor()
        searchController.reactor?.coordinatorDelegate = self
        navigationController.setViewControllers([searchController], animated: false)
    }
}

extension MainCoordinator: MainCoordinatorProtocol {
    
    func showDetails() {
        
    }
    
}
