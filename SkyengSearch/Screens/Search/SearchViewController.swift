import UIKit
import RxSwift
import ReactorKit
import RxDataSources

class SearchViewController: UIViewController, View {
    
    typealias Reactor = SearchReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.register(UITableViewCell.self, forCellReuseIdentifier: "AnyCell")
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
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func bind(reactor: SearchReactor) {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SearchSection>(configureCell: { (source, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case let .result(result):
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnyCell", for: indexPath)
                cell.textLabel?.text = result.meanings.map({ $0.translationText }).joined(separator: ", ")
                return cell
                
            case .loading:
                return tableView.dequeueReusableCell(withIdentifier: "AnyCell", for: indexPath)
            }
        })
        
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        debugPrint("updateSearchResults")
        reactor?.action.onNext(.search(searchController.searchBar.text ?? ""))
    }
    
}
