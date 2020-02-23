//
//  SearchBloc.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SearchBloc: BaseBlocProtocol {
    static let shared = SearchBloc()
    let stateRelay = PublishRelay<BaseStateProtocol>()
    var disposeBag = DisposeBag()
    
    init() {
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }

    func dispatch(event: BaseEventProtocol) {
        typealias Element = SearchStateProtocol
        event.applyAsync()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                guard let searchState = state as? SearchStateProtocol else {
                    return
                }
                
                self.stateRelay.accept(searchState)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.stateRelay.accept(ErrorSearchState(error: error as NSError))
            })
            .disposed(by: self.disposeBag)
    }
    
}
