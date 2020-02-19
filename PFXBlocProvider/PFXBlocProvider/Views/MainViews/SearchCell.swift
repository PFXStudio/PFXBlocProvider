//
//  SearchCell.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/19.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import UIKit
import Nuke

class SearchCellViewModel: BaseCellViewModel {
    var name: String?
    var score: String?
    var thumbPath: String?
}

class SearchCell: BaseCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func initialize() {
        self.nameLabel.text = ""
        self.scoreLabel.text = ""
        self.thumbImageView.image = nil
    }
    
    override func configure(viewModel: BaseCellViewModel) {
        guard let viewModel = viewModel as? SearchCellViewModel else {
            return
        }
        
        self.nameLabel.text = viewModel.name
        self.scoreLabel.text = viewModel.score
        guard let path = viewModel.thumbPath else {
            return
        }
        
        if let url = URL(string: path) {
            Nuke.loadImage(with: url, into: self.thumbImageView)
        }
    }
}
