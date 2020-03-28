import RxSwift
import ReactorKit

class DetailsReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let data: SearchResult
        
        var title: String {
            data.text
        }
        
        var sections: [DetailsSection] = []
        
        init(data: SearchResult) {
            self.data = data
            
            self.sections = [DetailsSection(index: 0, items: data.meanings.map(DetailsRow.meaning))]
        }
    }
    
    var initialState: DetailsReactor.State
    
    init(data: SearchResult) {
        initialState = State(data: data)
    }
    
    func mutate(action: DetailsReactor.Action) -> Observable<DetailsReactor.Mutation> {
        return .empty()
    }
    
    func reduce(state: DetailsReactor.State, mutation: DetailsReactor.Mutation) -> DetailsReactor.State {
        var state = state
        
        return state
    }
    
}
