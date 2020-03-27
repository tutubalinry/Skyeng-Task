import ReactorKit
import RxSwift
import RxCocoa

extension Reactor {
    
    func concat(_ mutations: [Mutation], with: Observable<Mutation> = .empty()) -> Observable<Mutation> {
        Observable.concat(mutations.map { .just($0) }).concat(with)
    }
    
    func concat(_ mutations: Mutation..., with: Observable<Mutation> = .empty()) -> Observable<Mutation> {
        concat(mutations, with: with)
    }
    
    func merge(_ mutations: [Mutation], with: Observable<Mutation> = .empty()) -> Observable<Mutation> {
        var observables: [Observable<Mutation>] = mutations.map { Observable.just($0) }
        observables.append(with)
        return .merge(observables)
    }
    
    func merge(_ mutations: Mutation..., with: Observable<Mutation> = .empty()) -> Observable<Mutation> {
        merge(mutations, with: with)
    }
}
