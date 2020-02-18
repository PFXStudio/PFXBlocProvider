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
    func applyAsync() -> Observable<SearchStateProtocol>
}

protocol SearchEventProtocol: EventProtocol {
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

    func applyAsync() -> Observable<SearchStateProtocol> {
        return PublishSubject<SearchStateProtocol>.create { [weak self] observer -> Disposable in
            observer.on(.next(FetchingSearchState()))
            guard let self = self else {
                observer.onError(NSError(domain: "\(#function) : \(#line)", code: BPError.system_deallocated.rawValue, userInfo: nil))
                return Disposables.create()
            }
            
            self.searchProvider.fetchingSearch(parameterDict: self.parameterDict)
                .subscribe(onSuccess: { searchResponseModel in
                    observer.onNext(FetchedSearchState(searchResponseModel: searchResponseModel))
                }) { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
