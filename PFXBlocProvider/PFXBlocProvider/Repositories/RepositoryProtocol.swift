//
//  RepositoryProtocol.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    func requestSearchList(parameterDict: Dictionary<String, String>) -> Observable<SearchResponseModel>
}
