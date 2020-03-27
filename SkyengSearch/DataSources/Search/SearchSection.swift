import RxDataSources

struct SearchSection {
    
    var index: Int
    var items: [SearchRow]
    
    init(index: Int, items: [SearchRow]) {
        self.index = index
        self.items = items
    }
    
}

extension SearchSection: AnimatableSectionModelType {
    
    typealias Identity = Int
    
    typealias Item = SearchRow
    
    var identity: Int {
        return 0
    }
    
    init(original: SearchSection, items: [SearchRow]) {
        self = original
        self.items = items
    }
}
