//
//  DetailProvider.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailProviderProtocol: BaseProviderProtocol {
}

class DetailProvider: DetailProviderProtocol {
    var disposeBag = DisposeBag()
    var repository: RepositoryProtocol = GithubRepository()
    
    deinit {
        self.disposeBag = DisposeBag()
    }
}
