//
//  SearchProvider.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchProvider {
    func fetchingSearch(text: String, page: Int) -> Observable<Any?>
}