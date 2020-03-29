import RxSwift
import ReactorKit
import Moya

let SearchPageSize: Int = 20

class SearchReactor: Reactor {
    
    enum Action {
        case search(String)
        case loadMore
        case select(IndexPath)
        case tableViewOffset(CGFloat)
    }
    
    enum Mutation {
        case isBusy(Bool)
        case word(String)
        case page(Int)
        case select(IndexPath)
        case results([SearchResult], clear: Bool)
        case tableViewOffset(CGFloat)
        case error(String?)
    }
    
    struct State {
        var sections: [SearchSection] = []
        
        var word: String = ""
        
        var page: Int = 1
        
        var isBusy: Bool = false
        
        var tableViewOffset: CGFloat = 0
        
        var error: String?
        
        var showEmptyLabel: Bool {
            return !isBusy && !word.isEmpty && sections.first?.items.count == 0
        }
    }
    
    var initialState: State = State()
    
    private var isLoadMore: Bool = false
    
    private var cancelRequest: PublishSubject<Void> = PublishSubject()
    
    weak var coordinatorDelegate: MainCoordinatorProtocol?
    
    func transform(action: Observable<SearchReactor.Action>) -> Observable<SearchReactor.Action> {
        let keyboardObservable: Observable<Action> = keyboard().map { .tableViewOffset($0) }
        
        return .merge(action, keyboardObservable)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .search(word):
            return merge(.word(word), .page(1), .isBusy(true), with: search(word: word, page: 1, pageSize: SearchPageSize, clear: true))
            
        case .loadMore:
            if isLoadMore {
                let page: Int = currentState.page + 1
                return merge(.page(page), .isBusy(true), with: search(word: currentState.word, page: page, pageSize: SearchPageSize, clear: false))
            }
            return .empty()
            
        case let .select(indexPath):
            return .just(.select(indexPath))
            
        case let .tableViewOffset(offset):
            return .just(.tableViewOffset(offset))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.error = nil
        
        switch mutation {
        case let .isBusy(isBusy):
            state.isBusy = isBusy
            
        case let .word(word):
            state.word = word
            
        case let .page(page):
            state.page = page
            
        case let .select(indexPath):
            guard let row = state.sections[safe: indexPath.section]?.items[safe: indexPath.row] else { return state }
            
            switch row {
            case let .result(result):
                coordinatorDelegate?.showDetails(result: result)
                
            default:
                return state
            }
            
        case let .results(results, clear: clear):
            var items: [SearchRow] = []
            if let first = state.sections.first, !clear {
                items = first.items.filter { $0 != .loading }
                results.forEach { result in
                    if !items.map({ $0.identity }).contains(String(result.id)) {
                        items.append(SearchRow.result(result))
                    }
                }
            } else {
                items = results.map(SearchRow.result)
            }
            if results.count == SearchPageSize {
                items.append(.loading)
            }
            isLoadMore = results.count == SearchPageSize
            state.sections = [SearchSection(index: 0, items: items)]
            
        case let .tableViewOffset(offset):
            state.tableViewOffset = offset
            
        case let .error(message):
            state.error = message
        }
        
        return state
    }
}

extension SearchReactor {
//    MARK: - Networking
    
    private func search(word: String, page: Int, pageSize: Int, clear: Bool) -> Observable<Mutation> {
        cancelRequest.onNext(())
        
        if word.isEmpty {
            return concat(.isBusy(false), .results([], clear: true))
        }
        
        return SkyengAPIProvider.shared.rx.request(.search(word: word, page: page, pageSize: pageSize))
            .asObservable()
            .takeUntil(cancelRequest)
            .map { response -> [SearchResult] in try parser(data: response.data) }
            .flatMap { [unowned self] results -> Observable<Mutation> in self.concat(.isBusy(false), .results(results, clear: clear)) }
            .catchError { [unowned self] error -> Observable<Mutation> in self.concat(.isBusy(false), .error(error.localizedDescription)) }
    }
    
}
