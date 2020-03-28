import RxDataSources

enum DetailsRow {
    case meaning(Meaning)
}

extension DetailsRow: IdentifiableType {
    
    typealias Identity = Int
    
    var identity: Int {
        switch self {
        case let .meaning(result):
            return result.id
        }
    }
}

extension DetailsRow: Equatable {
    
    static func ==(lhs: DetailsRow, rhs: DetailsRow) -> Bool {
        lhs.identity == rhs.identity
    }
    
}
