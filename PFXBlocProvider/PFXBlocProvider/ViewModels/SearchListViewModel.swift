//
//  SearchListViewModel.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/19.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

class SearchListViewModel {
    struct Input {
        var searchObserver: AnyObserver<String>
        var nextObserver: AnyObserver<String>
    }
    
    struct Output {
        var sections: Observable<[BaseSectionTableViewModel]>
        var loading: Observable<Bool>
    }
    
    var output: SearchListViewModel.Output!
    var input: SearchListViewModel.Input!
    private var sectionsSubject = BehaviorRelay<[BaseSectionTableViewModel]>(value: [BaseSectionTableViewModel()])
    private var loadingSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    private var searchSubject: PublishSubject<String> = PublishSubject()
    private var nextSubject: PublishSubject<String> = PublishSubject()
    private var pageIndex = 1
    private var requestEvent: SearchEventProtocol?

    private var disposeBag = DisposeBag()
    private let searchBloc = SearchBloc()
    private var parameterDict = ["" : ""]

    init() {
        self.output = SearchListViewModel.Output(sections: self.sectionsSubject.asObservable(), loading: self.loadingSubject.asObservable())
        self.input = Input(searchObserver: self.searchSubject.asObserver(), nextObserver: self.nextSubject.asObserver())
        
        self.searchSubject.distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.pageIndex = 1
                var oldValue = self.sectionsSubject.value.first!
                oldValue.items.removeAll()
                self.sectionsSubject.accept([oldValue])
                self.parameterDict = ["q" : text, "page" : "\(self.pageIndex)"]
                self.requestEvent = FetchingSearchEvent(parameterDict: self.parameterDict)
                self.searchBloc.dispatch(event: self.requestEvent!)
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

            }, onError: { error in
                
            })
            .disposed(by: self.disposeBag)
        
        self.searchBloc.stateRelay
            .subscribe(onNext: { [weak self] state in
                guard let self = self else  { return }
                if let _ = state as? FetchingSearchState {
                    self.loadingSubject.onNext(true)
                    return
                }
                
                if let fetchedSearchState = state as? FetchedSearchState {
                    guard var oldValue = self.sectionsSubject.value.first else {
                        return
                    }
                    
                    guard let items = fetchedSearchState.searchResponseModel.items else {
                        return
                    }
                    
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
                    self.loadingSubject.onNext(false)
                    return
                }
            

            }, onError: { error in
                
            })
            .disposed(by: self.disposeBag)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
}
