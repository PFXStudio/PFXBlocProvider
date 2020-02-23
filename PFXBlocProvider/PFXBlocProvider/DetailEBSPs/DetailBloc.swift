//
//  DetailBloc.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class DetailBloc: BaseBlocProtocol {
    static let shared = SearchBloc()
    let stateRelay = PublishRelay<BaseStateProtocol>()
    var disposeBag = DisposeBag()
    
    init() {
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }

    func dispatch(event: BaseEventProtocol) {
        event.applyAsync()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                guard let detailState = state as? DetailStateProtocol else {
                    return
                }
                
                self.stateRelay.accept(detailState)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.stateRelay.accept(ErrorDetailState(error: error as NSError))
            })
            .disposed(by: self.disposeBag)
    }
    
}
