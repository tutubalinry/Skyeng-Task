import UIKit
import RxSwift
import ReactorKit
import RxDataSources

class DetailsViewController: UIViewController, View {
    
    typealias Reactor = DetailsReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.estimatedRowHeight = 50
        view.rowHeight = UITableView.automaticDimension
        view.tableFooterView = UIView()
        view.register(MeaningCell.self)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func bind(reactor: DetailsReactor) {
        let dataSource = RxTableViewSectionedAnimatedDataSource<DetailsSection>(configureCell: { (source, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case let .meaning(meaning):
                let cell: MeaningCell = tableView.dequeue(for: indexPath)
                cell.setup(meaning: meaning)
                return cell
            }
        })
        
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: rx.title)
            .disposed(by: disposeBag)
    }
    
}
