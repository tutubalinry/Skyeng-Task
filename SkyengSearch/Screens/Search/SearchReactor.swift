import RxSwift
import ReactorKit
import Moya

let SearchPageSize: Int = 20

class SearchReactor: Reactor {
    
    enum Action {
        case search(String)
        case loadMore
    }
    
    enum Mutation {
        case word(String)
        case page(Int)
        case results([SearchResult], clear: Bool)
        case error(String?)
    }
    
    struct State {
        var sections: [SearchSection] = []
        
        var word: String = ""
        
        var page: Int = 1
    }
    
    var initialState: State = State()
    
    private var isLoadMore: Bool = false
    
    private var cancelRequest: PublishSubject<Void> = PublishSubject()
    
    weak var coordinatorDelegate: MainCoordinatorProtocol?
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .search(word):
            return merge(.word(word), .page(1), with: search(word: word, page: 1, pageSize: SearchPageSize, clear: true))
            
        case .loadMore:
            if isLoadMore {
                let page: Int = currentState.page + 1
                return merge(.page(page), with: search(word: currentState.word, page: page, pageSize: SearchPageSize, clear: false))
            }
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .word(word):
            state.word = word
            
        case let .page(page):
            state.page = page
            
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
            
        case let .error(message):
            debugPrint(">>>>>>>>>>>>>>>>: \(message ?? "-")")
        }
        
        return state
    }
}

extension SearchReactor {
//    MARK: - Networking
    
    private func search(word: String, page: Int, pageSize: Int, clear: Bool) -> Observable<Mutation> {
        cancelRequest.onNext(())
        
        if word.isEmpty {
            return .just(.results([], clear: true))
        }
        
        return SkyengAPIProvider.shared.rx.request(.search(word: word, page: page, pageSize: pageSize))
            .asObservable()
            .takeUntil(cancelRequest)
            .map { response -> [SearchResult] in try parser(data: response.data) }
            .flatMap { results -> Observable<Mutation> in .just(.results(results, clear: clear)) }
            .catchError { error -> Observable<Mutation> in .just(.error(error.localizedDescription)) }
    }
    
}
