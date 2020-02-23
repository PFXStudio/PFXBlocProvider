//
//  DetailState.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation

protocol DetailStateProtocol: BaseStateProtocol {
}

class IdleDetailState: DetailStateProtocol {
    
}

class ErrorDetailState: DetailStateProtocol {
    let error: NSError
    init(error: NSError) {
        self.error = error
    }
}
