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

extension Reactor {
    
    func keyboard() -> Observable<CGFloat> {
        let show = NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .map { notification in notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0?.height ?? 0 }
        
        let hide = NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return .merge(show, hide)
    }
    
}
