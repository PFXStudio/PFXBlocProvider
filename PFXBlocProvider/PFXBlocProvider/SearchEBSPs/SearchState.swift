//
//  SearchState.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation

protocol SearchStateProtocol: BaseStateProtocol {
}

class FetchingSearchState: SearchStateProtocol {
    
}

class FetchedSearchState: SearchStateProtocol {
    let searchResponseModel: SearchResponseModel
    init(searchResponseModel: SearchResponseModel) {
        self.searchResponseModel = searchResponseModel
    }
}

class EmptySearchState: SearchStateProtocol {
    
}

class IdleSearchState: SearchStateProtocol {
    
}

class ErrorSearchState: SearchStateProtocol {
    let error: NSError
    init(error: NSError) {
        self.error = error
    }
}
