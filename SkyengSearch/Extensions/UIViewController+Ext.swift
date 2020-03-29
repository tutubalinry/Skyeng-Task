import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var errorAlert: Binder<String?> {
        return Binder(base, scheduler: MainScheduler.asyncInstance) { (controller, message) in
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(ok)
            controller.show(alertController, sender: nil)
        }
    }
    
}
