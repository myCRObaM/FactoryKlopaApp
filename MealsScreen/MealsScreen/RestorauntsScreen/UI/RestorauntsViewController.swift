//
//  RestorauntsViewController.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Shared
import SnapKit

class RestorauntsViewController: UIViewController {
    //MARK: View
    let customView: RestorauntView = {
       let view = RestorauntView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
           
    
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "background")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    let gradientBackground: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: Init
    
    init(viewModel: RestorauntsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Variables
    let viewModel: RestorauntsViewModel
    let disposeBag = DisposeBag()
    weak var didSelectRestoraunt: SelectedRestorauntDelegate?
    weak var didSelectCategory: SelectedCategoryDelegate?
    var collectionView: UICollectionView!
    var reuseIndetifier = "CVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupViewModel()
    }
    //MARK: SetupViewModel
    func setupViewModel(){
        let input = RestorauntsViewModel.Input(getDataSubject: ReplaySubject<Bool>.create(bufferSize: 1))
        
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        input.getDataSubject.onNext(true)
        
        output.dataIsDoneSubject
        .observeOn(MainScheduler.instance)
        .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
            self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    //MARK: Setup view
    func setupView(){
        tableView.register(RestorauntsTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        view.addSubview(backgroundImage)
        view.insertSubview(customView, aboveSubview: backgroundImage)
        view.insertSubview(tableView, aboveSubview: customView)
        view.insertSubview(logoView, aboveSubview: backgroundImage)
        view.backgroundColor = .white
        view.insertSubview(gradientBackground, belowSubview: backgroundImage)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        customView.restorauntsButton.addTarget(self, action: #selector(restorauntsButtonPressed), for: .touchUpInside)
        customView.mealsButton.addTarget(self, action: #selector(mealsButtonPressed), for: .touchUpInside)
        
        restorauntsButtonPressed()
        
    }

    
    func setupConstraints(){
       customView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view).inset(10)
            make.top.equalTo(view).inset(UIScreen.main.bounds.height/6)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view)
            make.top.equalTo(customView.restorauntsButton.snp.bottom).offset(27)
        }
        
        gradientBackground.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage.snp.bottom)
            make.bottom.equalTo(customView.restorauntsButton).offset(20)
            make.leading.trailing.equalTo(view)
        }
        
        backgroundImage.snp.makeConstraints { (make) in
                   make.top.leading.trailing.equalTo(view)
                   make.height.equalTo(UIScreen.main.bounds.height/4.8)
               }
        
        logoView.snp.makeConstraints { (make) in
            make.leading.equalTo(customView.restorauntsButton)
            make.bottom.equalTo(customView.snp.top).offset(-30)
            make.width.equalTo(175)
            make.height.equalTo(48)
        }
    }
    
    //MARK: CollectionViewSetup
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIndetifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
    }
    
    @objc func restorauntsButtonPressed(){
        switch customView.mealsButton.isSelected {
        case true:
            collectionView.removeFromSuperview()
            whiteView.removeFromSuperview()
        case false:
            break
        }
        
        customView.restorauntsButton.isSelected = true
        customView.mealsButton.isSelected = false
    }
    
    @objc func mealsButtonPressed(){
        customView.restorauntsButton.isSelected = false
               customView.mealsButton.isSelected = true
        setupCollectionView()
       
        view.insertSubview(whiteView, aboveSubview: tableView)
        view.insertSubview(collectionView, aboveSubview: whiteView)
        
        whiteView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(tableView)
            make.leading.equalTo(tableView).offset(10)
            make.trailing.equalTo(tableView).offset(-10)
        }
    }
    
}
//MARK: table view extensions
extension RestorauntsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restoraunts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? RestorauntsTableViewCell  else {
                   fatalError("The dequeued cell is not an instance of RestorauntsTableViewCell.")
               }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        cell.setupCell(name: viewModel.restoraunts[indexPath.row])
        cell.selectionStyle = .none
               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRestoraunt?.openMealCategories(screenData: viewModel.restoraunts[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

extension RestorauntsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrayOfCategorySortedMeals(restorants: viewModel.restoraunts).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = viewModel.returnCellData(type: viewModel.arrayOfCategorySortedMeals(restorants: viewModel.restoraunts)[indexPath.row])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIndetifier, for: indexPath) as! CollectionViewCell
        cell.setupCell(name: data.0, url: data.1)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCategory?.openMealCategories(screenData: viewModel.arrayOfCategorySortedMeals(restorants: viewModel.restoraunts)[indexPath.row])
    }
    
    
}
