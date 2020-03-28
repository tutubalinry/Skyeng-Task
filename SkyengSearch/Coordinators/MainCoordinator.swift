import UIKit

protocol MainCoordinatorProtocol: class {
    func showDetails(result: SearchResult)
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
    
    func showDetails(result: SearchResult) {
        DispatchQueue.main.async { [weak self] in
            let view = DetailsViewController()
            view.reactor = DetailsReactor(data: result)
            self?.navigationController.pushViewController(view, animated: true)
        }
    }
    
}
