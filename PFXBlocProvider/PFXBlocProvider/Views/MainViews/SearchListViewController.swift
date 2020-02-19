//
//  SearchListViewController.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/19.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class SearchListViewController: UIViewController {
    var viewModel = SearchListViewModel()
    var disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 60.0
            tableView.tableFooterView = UIView()
            tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
    }

    private var rxDataSource: RxTableViewSectionedAnimatedDataSource<BaseSectionTableViewModel>?

    deinit {
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rxDataSource = RxTableViewSectionedAnimatedDataSource<BaseSectionTableViewModel>(
            configureCell: { dataSource, tableView, indexPath, sm in
                guard let viewModel = try? (dataSource.model(at: indexPath) as! BaseCellViewModel), // swiftlint:disable:this force_cast
                    let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier) as? ConfigurableCell else {
                    assert(true)
                    return UITableViewCell()
                }
                cell.configure(viewModel: viewModel)
                return cell
        })

        rxDataSource?.animationConfiguration = AnimationConfiguration(insertAnimation: .top,
                                                                      reloadAnimation: .automatic,
                                                                      deleteAnimation: .automatic)

        
        self.viewModel.output.sections.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: self.rxDataSource!))
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.willDisplayCell
            .filter { [weak self] (cell, indexPath) -> Bool in
                guard let self = self else { return false }
                let count = self.tableView.numberOfRows(inSection: 0)
                return indexPath.row > count - 3
            }
            .subscribe(onNext: { [weak self] (cell, indexPath) in
                guard let self = self else { return }
                self.viewModel.input.nextObserver.onNext("")
            })
            .disposed(by: self.disposeBag)

    }
}
