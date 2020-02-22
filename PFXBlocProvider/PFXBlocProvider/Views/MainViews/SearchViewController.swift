//
//  SearchViewController.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import NVActivityIndicatorView

class SearchViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyView: UIView!

    weak var searchListViewController: SearchListViewController?
    var disposeBag = DisposeBag()
    var viewModel: SearchListViewModel?
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let destination = segue.destination as? SearchListViewController else {
            return
        }
        
        self.viewModel = destination.viewModel
        self.searchListViewController = destination

        self.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.viewModel?.input.searchObserver.onNext(text)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel?.output.loading
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading == false {
                    self.stopAnimating()
                    return
                }
                
                let size = CGSize(width: 30, height: 30)
                let selectedIndicatorIndex = 15
                let indicatorType = self.presentingIndicatorTypes[selectedIndicatorIndex]
                self.startAnimating(size, message: "Loading...", type: indicatorType, fadeInAnimation: nil)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel?.output.empty
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEmpty in
                guard let self = self else { return }
                self.emptyView.isHidden = !isEmpty
            })
            .disposed(by: self.disposeBag)
    }
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
}
