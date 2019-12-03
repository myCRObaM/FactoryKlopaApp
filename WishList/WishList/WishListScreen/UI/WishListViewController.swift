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

class WishListViewController: UIViewController {
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
    init(viewModel: WishListViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
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
        
        output.emptySubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: { [unowned self] bool in
                self.setupEmptyState()
            }).disposed(by: disposeBag)
        
        self.deleteCells(subject: output.deleteCell).disposed(by: disposeBag)
        viewModel.input.getData.onNext(true)
    }
    
    func setupView(){
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WishListCell.self, forCellReuseIdentifier: "MTC")
        tableView.register(WishListTotal.self, forCellReuseIdentifier: "WLT")
        
        tableView.tableFooterView = UIView()
        
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
        let alert = UIAlertController(title: NSLocalizedString("popUpErrorTitle", comment: ""), message: NSLocalizedString("popUpErrorDesc", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        childHasFinished?.viewControllerHasFinished()
    }
    
    deinit {
        print("Deinit: ", self)
    }
    
    
    func deleteCells(subject: PublishSubject<IndexPath>) -> Disposable {
        subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: { [unowned self] bool in
                self.tableView.reloadData()
            })
        
    }
    
    func setupEmptyState(){
        let coverView = UIView()
        let emptyLabel = UILabel()
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let customFont = UIFont(name: "Rubik-Bold", size: 18)
        
        coverView.backgroundColor = .white
        
        emptyLabel.text = NSLocalizedString("wishListEmpty", comment: "")
        emptyLabel.font = customFont
        emptyLabel.numberOfLines = 2
        emptyLabel.textAlignment = .center
        
        view.addSubview(coverView)
        coverView.addSubview(emptyLabel)
        
        coverView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView)
        }
        
        emptyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(coverView)
            make.centerX.equalTo(coverView)
        }
        
    }
}

extension WishListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.returnNumberOfCells(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.returnACorrectCell(index: indexPath){
        case true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WLT", for: indexPath) as? WishListTotal  else {
                fatalError("The dequeued cell is not an instance of RestorauntsTableViewCell.")
            }
            let data = viewModel.output!.screenData![indexPath.section].data
            cell.setupCell(ammount: viewModel.returnTotalAmount(data: data))
            cell.separatorInset = .zero
            return cell
        case false:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MTC", for: indexPath) as? WishListCell  else {
                fatalError("The dequeued cell is not an instance of RestorauntsTableViewCell.")
            }
            let data = viewModel.output!.screenData![indexPath.section].data[indexPath.row]
            cell.setupCell(data: viewModel.returnDataForCell(data: data))
            cell.separatorInset = .zero
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canPress(index: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output?.screenData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.input.deleteMeal.onNext(indexPath)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let headerLabel = UILabel()
        let mobLabel = UILabel()
        let telLabel = UILabel()
        
        var data = (rName: "", mText: "", tText: "", price: "")
        let priceLabel = UILabel()
        data = viewModel.dataForHeader(data: viewModel.output!.screenData![section])
        
        header.backgroundColor = UIColor.init(named: "headerBackground")
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        mobLabel.translatesAutoresizingMaskIntoConstraints = false
        telLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.text = data.rName.uppercased()
        priceLabel.text = data.price
        mobLabel.text = data.mText
        telLabel.text = data.tText
        
        let customFont = UIFont(name: "Rubik-Bold", size: 14)
        let customFontContact = UIFont(name: "Rubik-Italic", size: 14)
        
        priceLabel.font = customFont
        headerLabel.font = customFont
        mobLabel.font = customFontContact
        telLabel.font = customFontContact
        
        header.addSubview(headerLabel)
        header.addSubview(priceLabel)
        header.addSubview(mobLabel)
        header.addSubview(telLabel)
        
        headerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(header).offset(5)
            make.leading.equalTo(header).offset(10)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(header)
            make.trailing.equalTo(header).offset(-10)
        }
        
        mobLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(5)
            make.leading.equalTo(header).offset(10)
        }
        telLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mobLabel.snp.bottom).offset(5)
            make.leading.equalTo(header).offset(10)
            make.bottom.equalTo(header).offset(-5)
        }
        
        return header
    }
    
}
