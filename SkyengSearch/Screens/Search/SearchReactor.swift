import RxSwift
import ReactorKit
import Moya

let SearchPageSize: Int = 30

class SearchReactor: Reactor {
    
    enum Action {
        case search(String)
    }
    
    enum Mutation {
        case results([SearchResult])
        case error(String?)
    }
    
    struct State {
        var results: [SearchRow] = []
    }
    
    var initialState: State = State()
    
    private var currentRequest: Cancellable?
    
    weak var coordinatorDelegate: MainCoordinatorProtocol?
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .search(word):
            return search(word: word, page: 0, pageSize: SearchPageSize)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .results(results):
            state.results.append(contentsOf: results.map(SearchRow.result))
            
        case let .error(message):
            debugPrint(message)
        }
        
        return state
    }
}

extension SearchReactor {
//    MARK: - Networking
    
    private func search(word: String, page: Int, pageSize: Int) -> Observable<Mutation> {
        currentRequest?.cancel()
        
        if word.isEmpty {
            return .just(.results([]))
        }
        
        return Observable<[SearchResult]>.create { [unowned self] observer -> Disposable in
            self.currentRequest = SkyengAPIProvider.shared.request(.search(word: word, page: page, pageSize: pageSize)) { result in
                switch result {
                case let .success(response):
                    do {
                        let decoder = JSONDecoder()
                        observer.onNext(try decoder.decode([SearchResult].self, from: response.data))
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                    
                case let .failure(error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
        .flatMap { results -> Observable<Mutation> in .just(.results(results)) }
        .catchError { error -> Observable<Mutation> in .just(.error(error.localizedDescription)) }
    }
    
}
