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
            
            guard let page = self.parameterDict["page"], let q = self.parameterDict["q"] else {
                observer.onError(NSError(domain: "\(#function) : \(#line)", code: BPError.network_invalid_parameter.rawValue, userInfo: nil))
                return Disposables.create()
            }
            
            if q.count <= 0 {
                observer.onError(NSError(domain: "\(#function) : \(#line)", code: BPError.network_invalid_parameter.rawValue, userInfo: nil))
                return Disposables.create()
            }
            
            if Int(page) == nil {
                observer.onError(NSError(domain: "\(#function) : \(#line)", code: BPError.network_invalid_parameter.rawValue, userInfo: nil))
                return Disposables.create()
            }
            
            return Disposables.create()
            } as! Observable<Element>
    }
}
