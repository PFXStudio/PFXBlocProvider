//
//  DetailViewModel.swift
//  PFXBlocProvider
//
//  Created by succorer on 23/02/2020.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class DetailViewModel {
    struct Input {
        var searchObserver: AnyObserver<String>
        var nextObserver: AnyObserver<String>
    }
    
    struct Output {
        var sections: Observable<[BaseSectionTableViewModel]>
        var loading: Observable<Bool>
        var empty: Observable<Bool>
        var error: Observable<NSError>
    }
    
    var output: DetailViewModel.Output!
    var input: DetailViewModel.Input!
    private var sectionsSubject = BehaviorRelay<[BaseSectionTableViewModel]>(value: [BaseSectionTableViewModel()])
    private var emptySubject = BehaviorRelay<Bool>(value: true)
    private var loadingSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    private var searchSubject: PublishSubject<String> = PublishSubject()
    private var nextSubject: PublishSubject<String> = PublishSubject()
    private var errorSubject: PublishSubject<NSError> = PublishSubject()
    private var pageIndex = 1
    private var requestEvent: BaseEventProtocol?

    private var disposeBag = DisposeBag()
    private let searchBloc = SearchBloc()
    private var parameterDict = ["" : ""]

    init() {
        self.output = DetailViewModel.Output(sections: self.sectionsSubject.asObservable(), loading: self.loadingSubject.asObservable(), empty: self.emptySubject.asObservable(), error: self.errorSubject.asObservable())
        self.input = Input(searchObserver: self.searchSubject.asObserver(), nextObserver: self.nextSubject.asObserver())
        
        self.searchSubject.distinctUntilChanged()
            .skip(1)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.pageIndex = 1
                self.sectionsSubject.accept([BaseSectionTableViewModel()])
                if text.count <= 0 {
                    self.emptySubject.accept(true)
                    return
                }
                
                self.parameterDict = ["q" : text, "page" : "\(self.pageIndex)"]
                self.requestEvent = FetchingSearchEvent(parameterDict: self.parameterDict)
                self.searchBloc.dispatch(event: self.requestEvent!)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorSubject.onNext(error as NSError)
            })
            .disposed(by: self.disposeBag)
        
        self.nextSubject
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.parameterDict.removeValue(forKey: "page")
                self.pageIndex = self.pageIndex + 1
                self.parameterDict["page"] = "\(self.pageIndex)"
                self.requestEvent = FetchingSearchEvent(parameterDict: self.parameterDict)
                self.searchBloc.dispatch(event: self.requestEvent!)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorSubject.onNext(error as NSError)
            })
            .disposed(by: self.disposeBag)
        
        self.searchBloc.stateRelay
            .subscribe(onNext: { [weak self] state in
                guard let self = self else  { return }
                if let _ = state as? FetchingSearchState {
                    self.loadingSubject.onNext(true)
                    return
                }
                
                self.loadingSubject.onNext(false)
                if let fetchedSearchState = state as? FetchedSearchState {
                    guard var oldValue = self.sectionsSubject.value.first else {
                        return
                    }
                    
                    guard let items = fetchedSearchState.searchResponseModel.items else {
                        return
                    }
                    
                    self.emptySubject.accept(false)
                    for i in items {
                        let viewModel = SearchCellViewModel(reuseIdentifier: String(describing: SearchCell.self), identifier: String(describing: SearchCell.self) + String.random())
                        viewModel.name = i.login
                        viewModel.score = "\(i.score)"
                        viewModel.thumbPath = i.avatar_url
                        oldValue.items.append(viewModel)
                    }
                    
                    self.sectionsSubject.accept([oldValue])
                    
                    print("fetchedSearchState")
                    return
                }
            
                if let _ = state as? IdleSearchState {
                    print("idleSearchState")
                    self.requestEvent = nil
                    return
                }
                
                if let _ = state as? EmptySearchState {
                    print("EmptySearchState")
                    self.sectionsSubject.accept([BaseSectionTableViewModel()])
                    self.emptySubject.accept(true)
                    return
                }
                
                if let errorState = state as? ErrorSearchState {
                    print("ErrorSearchState")
                    self.errorSubject.onNext(errorState.error)
                    return
                }

                print("invalid state : \(state)")

            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorSubject.onNext(error as NSError)
            })
            .disposed(by: self.disposeBag)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
}
