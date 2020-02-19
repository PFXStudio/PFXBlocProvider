//
//  BaseCellViewModel.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/19.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import RxDataSources

public class BaseCellViewModel: IdentifiableType, Equatable {

    let reuseIdentifier: String
    let identifier: String

    init(reuseIdentifier: String, identifier: String) {
        self.reuseIdentifier = reuseIdentifier
        self.identifier = identifier
    }

    // MARK: - IdentifiableType

    public typealias Identity = String

    public var identity : Identity {
        return identifier
    }

    // MARK: - Equatable

    public static func == (lhs: BaseCellViewModel, rhs: BaseCellViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}

