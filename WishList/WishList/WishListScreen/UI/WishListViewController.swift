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
    weak var childHasFinished: CoordinatorDelegate?
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
        let output = viewModel.transform(input: WishListViewModel.Input(getData: ReplaySubject<Bool>.create(bufferSize: 1), deleteMeal: PublishSubject<IndexPath>()))
        
        for disposable in output.disposables{
            disposable.disposed(by: disposeBag)
        }
        
        output.dataReady
        .observeOn(MainScheduler.instance)
        .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        output.errorSubject
             .observeOn(MainScheduler.instance)
             .subscribeOn(viewModel.dependencies.scheduler)
             .subscribe(onNext: { [unowned self] bool in
                self.showPopUp()
             }).disposed(by: disposeBag)
        
        self.deleteCells(subject: output.deleteCell).disposed(by: disposeBag)
        viewModel.input.getData.onNext(true)
    }
    
    func setupView(){
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WishListCell.self, forCellReuseIdentifier: "MTC")
        
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
    
    func showPopUp(){
        let alert = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    deinit {
        print("Deinit: ", self)
        childHasFinished?.viewControllerHasFinished()
    }
    
    
    func deleteCells(subject: PublishSubject<IndexPath>) -> Disposable {
        subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: { [unowned self] bool in
                
                self.viewModel.restoraunts[bool.section].1.remove(at: bool.row)
                self.tableView.deleteRows(at: [bool], with: .automatic)
            })
        
    }
}

extension WishListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restoraunts[section].1.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = viewModel.restoraunts[indexPath.section].1[indexPath.row]
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "MTC", for: indexPath) as? WishListCell  else {
               fatalError("The dequeued cell is not an instance of RestorauntsTableViewCell.")
           }
        cell.setupCell(name: viewModel.meals[index])
           cell.separatorInset = .zero
           return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.deleteMeal.onNext(indexPath)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.restoraunts.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let label = UILabel()
        let jnLabel = UILabel()
        
        header.backgroundColor = UIColor(red: 255/255.0, green: 184/255.0, blue: 14/255.0, alpha: 1)
        
        jnLabel.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = viewModel.restoraunts[section].0.uppercased()
        
        let customFont = UIFont(name: "Rubik-Bold", size: 14)
        
        jnLabel.font = customFont
        label.font = customFont
        
        
        header.addSubview(label)
        header.addSubview(jnLabel)
        
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(header)
            make.leading.equalTo(header).offset(10)
        }
        
        jnLabel.snp.makeConstraints { (make) in
                       make.centerY.equalTo(header)
                       make.trailing.equalTo(header).offset(-10)
        }
        
        switch viewModel.isPizza(data: viewModel.meals[viewModel.restoraunts[section].1[0]]){
        case true:
            jnLabel.text = "J      N"
        case false:
            jnLabel.text = "N"
        }
        return header
    }
    
}
