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

extension ObservableType {
    
    public func mapObject<T: Codable>(type: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let responseTuple = data as? (HTTPURLResponse, Data)

            guard let jsonData = responseTuple?.1 else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
                )
            }
            
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: jsonData)
            
            return Observable.just(object)
        }
    }
    
    public func mapArray<T: Codable>(type: T.Type) -> Observable<[T]> {
        return flatMap { data -> Observable<[T]> in
            let responseTuple = data as? (HTTPURLResponse, Data)
            
            guard let jsonData = responseTuple?.1 else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
                )
            }
            
            let decoder = JSONDecoder()
            let objects = try decoder.decode([T].self, from: jsonData)
            
            return Observable.just(objects)
        }
    }
}

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
