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
import RealmSwift


public class WishListViewController: UIViewController {
    //MARK: ViewElements
    
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        self.setupView()
        self.setupConstraints()
        setupViewModel()
    }
    
    func setupViewModel(){
        let output = viewModel.transform(input: WishListViewModel.Input(getData: ReplaySubject<Bool>.create(bufferSize: 1), deleteMeal: PublishSubject<Int>()))
        
        for disposable in output.disposables{
            disposable.disposed(by: disposeBag)
        }
        
        output.dataReady
        .observeOn(MainScheduler.instance)
        .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.input.getData.onNext(true)
    }
    
    func setupView(){
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SortedByNameTableViewCell.self, forCellReuseIdentifier: "MTC")
        
        backgroundView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func setupConstraints(){
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundView.customView.snp.top).offset(20)
            make.bottom.leading.trailing.equalTo(view)
        }
    }
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: false)
    }
}

extension WishListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meals.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "MTC", for: indexPath) as? SortedByNameTableViewCell  else {
               fatalError("The dequeued cell is not an instance of RestorauntsTableViewCell.")
           }
        cell.setupCell(name: viewModel.meals[indexPath.row])
           cell.separatorInset = .zero
           return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.deleteMeal.onNext(indexPath.row)
    }
    
}
