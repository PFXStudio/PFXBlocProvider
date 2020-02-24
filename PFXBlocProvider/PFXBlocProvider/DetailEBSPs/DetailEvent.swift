//
//  DetailEvent.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailEventProtocol: BaseEventProtocol {
}

class FetchingDetailEvent: DetailEventProtocol {
    var disposeBag = DisposeBag()
    let parameterDict: [String : String]
    var detailProvider: DetailProviderProtocol = DetailProvider()
    
    init(parameterDict: [String : String]) {
        self.parameterDict = parameterDict
    }

    deinit {
        self.disposeBag = DisposeBag()
    }
    
    func applyAsync<Element>() -> Observable<Element> {
        return PublishSubject<BaseStateProtocol>.create { [weak self] observer -> Disposable in
            guard let self = self else {
                observer.onError(NSError(domain: "\(#function) : \(#line)", code: BPError.system_deallocated.rawValue, userInfo: nil))
                return Disposables.create()
            }
            
            return Disposables.create()
            } as! Observable<Element>
    }
}
