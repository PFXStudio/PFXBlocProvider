//
//  SearchProvider.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchProviderProtocol {
    func fetchingSearch(parameterDict: [String : String]) -> Single<SearchResponseModel>
}

class SearchProvider: SearchProviderProtocol {
    var disposeBag = DisposeBag()
    var repository: RepositoryProtocol = GithubRepository()
    
    deinit {
        self.disposeBag = DisposeBag()
    }

    func fetchingSearch(parameterDict: [String : String]) -> Single<SearchResponseModel> {
        return Single<SearchResponseModel>.create { [weak self] single in
            guard let self = self else {
                single(.error(NSError(domain: "\(#function) : \(#line)", code: BPError.system_deallocated.rawValue, userInfo: nil)))
                return Disposables.create()
            }
            
            self.repository.requestSearchList(parameterDict: parameterDict)
                .subscribe(onNext: { [weak self] searchResponseModel in
                    guard let self = self else {
                        single(.error(NSError(domain: "\(#function) : \(#line)", code: BPError.system_deallocated.rawValue, userInfo: nil)))
                        return
                    }
                    
                    single(.success(searchResponseModel))
                    return
                }, onError: { error in
                    single(.error(error))
                    return
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
   
}
