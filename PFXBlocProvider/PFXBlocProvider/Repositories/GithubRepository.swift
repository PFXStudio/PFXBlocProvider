//
//  GithubRepository.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

class GithubRepository : RepositoryProtocol {
    var disposeBag = DisposeBag()
    var basePath: String = "https://api.github.com/search/users"
    // https://api.github.com/search/users?q=tom&page=3
    
    func requestSearchList(parameterDict: Dictionary<String, String>) -> Observable<SearchResponseModel> {
        RxAlamofire.requestData(.get, URL(string: self.basePath)!, parameters: parameterDict, headers: nil)
            .mapObject(type: SearchResponseModel.self)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
}
