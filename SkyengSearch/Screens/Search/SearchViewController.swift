import UIKit
import RxSwift
import ReactorKit
import RxDataSources

class SearchViewController: UIViewController, View {
    
    typealias Reactor = SearchReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.estimatedRowHeight = 50
        view.rowHeight = UITableView.automaticDimension
        view.register(SearchResultCell.self, LoadingCell.self)
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Input word"
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        title = "Search"
        
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func bind(reactor: SearchReactor) {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SearchSection>(configureCell: { (source, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case let .result(result):
                let cell: SearchResultCell = tableView.dequeue(for: indexPath)
                cell.setup(result: result)
                return cell
                
            case .loading:
                let cell: LoadingCell = tableView.dequeue(for: indexPath)
                return cell
            }
        })
        
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isReachedBottom(withTolerance: 30) {
            reactor?.action.onNext(.loadMore)
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        reactor?.action.onNext(.search(searchController.searchBar.text ?? ""))
    }
    
}
