//
//  BaseBlocProtocol.swift
//  PFXBlocProvider
//
//  Created by succorer on 23/02/2020.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation

// 비즈니스 로직 관제 프로토콜
protocol BaseBlocProtocol {
    func dispatch(event: BaseEventProtocol)
}
