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

protocol BlocProtocol {
    func dispatch(event: EventProtocol)
}

class SearchBloc: BlocProtocol {
    static let shared = SearchBloc()
    let stateRelay = PublishRelay<StateProtocol>()
    var disposeBag = DisposeBag()
    
    init() {
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }

    func dispatch(event: EventProtocol) {
        event.applyAsync()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else {
                    return
                }
                
                self.stateRelay.accept(state)
            }, onError: { error in
                    
            })
            .disposed(by: self.disposeBag)
    }
    
}
