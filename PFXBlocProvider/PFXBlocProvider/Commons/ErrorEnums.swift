//
//  ErrorEnums.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/18.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation

public enum BPError: Int {
    case network_invalid_url = 40000
    case network_invalid_response_data
    case network_invalid_parameter

    case system_deallocated = 44444
}

struct AdaptError: Error {
    let error: NSError
}

extension Error {
    var nsError: NSError? { return (self as? AdaptError)?.error }
}

