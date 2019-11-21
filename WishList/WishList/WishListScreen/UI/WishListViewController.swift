//
//  WishListViewController.swift
//  WishList
//
//  Created by Matej Hetzel on 21/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Shared
import SnapKit


public class WishListViewController: UIViewController {
    //MARK: ViewElements
    
    //MARK: Variables
    let viewModel: WishListViewModel
    let disposeBag = DisposeBag()
    let backgroundView = BackgroundView()
    
    //MARK: init
    public init(viewModel: WishListViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    func setupViewModel(){
        let output = viewModel.transform(input: WishListViewModel.Input(getData: ReplaySubject<Bool>.create(bufferSize: 1)))
        
        for disposable in output.disposables{
            disposable.disposed(by: disposeBag)
        }
        
        output.dataReady
        .observeOn(MainScheduler.instance)
        .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
            self.setupView()
            self.setupConstraints()
            }).disposed(by: disposeBag)
        
        viewModel.input.getData.onNext(true)
    }
    
    func setupView(){
        view.addSubview(backgroundView)
        
        backgroundView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func setupConstraints(){
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: false)
    }
}
