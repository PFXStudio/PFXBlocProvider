//
//  BaseCell.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/19.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol Configurable where Self: UITableViewCell {
    func configure(viewModel: BaseCellViewModel)
}

typealias ConfigurableCell = UITableViewCell & Configurable

class BaseCell: ConfigurableCell {

    var disposeBag = DisposeBag()

    func configure(viewModel: BaseCellViewModel) {}

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
