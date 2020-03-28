import UIKit
import RxSwift
import RxCocoa

extension UITableView {
    
    final func register(_ classes: [UITableViewCell.Type]) {
        classes.forEach { register($0.self, forCellReuseIdentifier: $0.identifier) }
    }
    
    final func register(_ classes: UITableViewCell.Type...) {
        register(classes)
    }
    
    final func dequeue<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Cast to \(T.self) error!")
        }
        return cell
    }
    
}

extension Reactive where Base: UITableView {
    
    var deselect: Binder<IndexPath> {
        return Binder(base, scheduler: MainScheduler.asyncInstance) { (tableView, indexPath) in
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
 
    var contentInset: Binder<UIEdgeInsets> {
        return Binder(base, scheduler: MainScheduler.asyncInstance, binding: { (tableView, insets) in
            tableView.contentInset = insets
        })
    }
}
