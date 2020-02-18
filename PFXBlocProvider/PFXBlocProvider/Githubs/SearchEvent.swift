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
    func applyAsync() -> Single<SearchStateProtocol>
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

    func applyAsync() -> Single<SearchStateProtocol> {
        return Single<SearchStateProtocol>.create { [weak self] single in
            guard let self = self else {
                single(.error(NSError(domain: "", code: 0, userInfo: nil)))
                return Disposables.create()
            }
            
            self.searchProvider.fetchingSearch(parameterDict: self.parameterDict)
                .subscribe(onSuccess: { searchResponseModel in
                    single(.success(FetchedSearchState(searchResponseModel: searchResponseModel)))
                }) { error in
                    single(.error(error))
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
