import RxDataSources

struct DetailsSection {
    
    var index: Int
    var items: [DetailsRow]
    
    init(index: Int, items: [DetailsRow]) {
        self.index = index
        self.items = items
    }
    
}

extension DetailsSection: AnimatableSectionModelType {
    
    typealias Identity = Int
    
    typealias Item = DetailsRow
    
    var identity: Int {
        return 0
    }
    
    init(original: DetailsSection, items: [DetailsRow]) {
        self = original
        self.items = items
    }
}
