import RxDataSources

enum SearchRow {
    case result(SearchResult)
    case loading
}

extension SearchRow: IdentifiableType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
        case let .result(result):
            return String(result.id)
            
        case .loading:
            return "loading"
        }
    }
}

extension SearchRow: Equatable {
    
    static func ==(lhs: SearchRow, rhs: SearchRow) -> Bool {
        lhs.identity == rhs.identity
    }
    
}
