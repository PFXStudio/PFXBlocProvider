//
//  SearchState.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation

protocol SearchState {
}

class FetchingSearchState: SearchState {
    
}

class FetchedSearchState: SearchState {
    
}

class EmptySearchState: SearchState {
    
}

class IdleSearchState: SearchState {
    
}
