import UIKit

protocol Coordinator: class {
    
    var rootViewController: UIViewController { get }
    
    func start()
    
}
