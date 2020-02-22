//
//  SearchEvent.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift

protocol EventProtocol {
    func applyAsync() -> Observable<StateProtocol>
}

protocol SearchEventProtocol: EventProtocol {
    typealias Element = SearchStateProtocol
//    func applyAsync<Element>() -> Observable<Element> {
//        return PublishSubject<SearchStateProtocol>.create { observer -> Disposable in
//            return Disposables.create()
//            } as! Observable<Element>
//    }
}

class FetchingSearchEvent: SearchEventProtocol {
    var disposeBag = DisposeBag()
    let parameterDict: [String : String]
    var searchProvider: SearchProviderProtocol = SearchProvider()
    
    init(parameterDict: [String : String]) {
        self.parameterDict = parameterDict
    }

    deinit {
        self.disposeBag = DisposeBag()
    }

    func applyAsync<Element>() -> Observable<Element> {
        return PublishSubject<StateProtocol>.create { [weak self] observer -> Disposable in
            observer.on(.next(FetchingSearchState()))
            guard let self = self else {
                observer.onError(NSError(domain: "\(#function) : \(#line)", code: BPError.system_deallocated.rawValue, userInfo: nil))
                return Disposables.create()
            }
            
            self.searchProvider.fetchingSearch(parameterDict: self.parameterDict)
                .subscribe(onSuccess: { [weak self] searchResponseModel in
                    defer {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            observer.onNext(IdleSearchState())
                        }
                    }
                    guard let self = self else {
                        observer.onError(NSError(domain: "\(#function) : \(#line)", code: BPError.system_deallocated.rawValue, userInfo: nil))
                        return
                    }
                    
                    let page = self.parameterDict["page"]
                    if page == "1" && (searchResponseModel.items == nil || searchResponseModel.items!.count <= 0) {
                        observer.onNext(EmptySearchState())
                        return
                    }

                    observer.onNext(FetchedSearchState(searchResponseModel: searchResponseModel))
                }) { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
            } as! Observable<Element>
    }
}
