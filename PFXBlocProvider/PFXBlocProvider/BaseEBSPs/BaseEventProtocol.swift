//
//  BaseEventProtocol.swift
//  PFXBlocProvider
//
//  Created by succorer on 23/02/2020.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift

// ViewModel -> Bloc에게 전달하는 이벤트 프로토콜
protocol BaseEventProtocol {
    // 비즈니스 로직 실행
    func applyAsync() -> Observable<BaseStateProtocol>
}
