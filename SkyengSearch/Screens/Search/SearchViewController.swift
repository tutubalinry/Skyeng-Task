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
        view.tableFooterView = UIView()
        view.register(SearchResultCell.self, LoadingCell.self)
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "search.input_word".localized()
        return controller
    }()
    
    private let emptyLabel: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "search.nothing_found".localized(), attributes: [.font : UIFont.italicSystemFont(ofSize: 48), .foregroundColor : UIColor.gray])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        title = "search.title".localized()
        
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        view.addSubview(emptyLabel)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
        
        reactor.state.map { !$0.showEmptyLabel }
            .distinctUntilChanged()
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.tableViewOffset }
            .distinctUntilChanged()
            .map { UIEdgeInsets(top: 0, left: 0, bottom: $0, right: 0) }
            .bind(to: tableView.rx.contentInset)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.error }
            .filterNil()
            .bind(to: rx.errorAlert)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { Reactor.Action.select($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: tableView.rx.deselect)
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
