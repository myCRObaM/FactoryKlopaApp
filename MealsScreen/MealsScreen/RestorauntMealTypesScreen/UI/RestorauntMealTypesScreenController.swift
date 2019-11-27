//
//  RestorauntMealTypesScreenController.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Shared

class RestorauntMealTypesScreenController: UIViewController {
    //MARK: ViewElements
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mealNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont(name: "Rubik-Medium", size: 28.51)
        view.font = customFont
        view.text = ""
        view.numberOfLines = 1
        return view
    }()
    
    //MARK: init
    init(viewModel: RestorauntMealTypesModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Variables
    let viewModel: RestorauntMealTypesModel
    let disposeBag = DisposeBag()
    let backgroundView = BackgroundView()
    weak var didSelectMealName: didSelectMealName?
    weak var childHasFinished: CoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
        setupViewModel()
        self.setupData()
    }
    
    func setupViewModel(){
        let input = RestorauntMealTypesModel.Input(getData: ReplaySubject<Bool>.create(bufferSize: 1))
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        
        output.dataReady
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: {  bool in
          
            }).disposed(by: disposeBag)
        
        output.errorSubject
        .observeOn(MainScheduler.instance)
                   .subscribeOn(viewModel.dependencies.scheduler)
                   .subscribe(onNext: { [unowned self] bool in
                    self.showPopUp()
                   }).disposed(by: disposeBag)
        
        viewModel.input.getData.onNext(true)
    }
    
    func setupView(){        
        view.addSubview(backgroundView)
        view.insertSubview(tableView, aboveSubview: backgroundView)
        view.backgroundColor = .white
        view.insertSubview(mealNameLabel, aboveSubview: backgroundView)
        tableView.register(MealTypeCell.self, forCellReuseIdentifier: "MTC")
        tableView.delegate = self
        tableView.dataSource = self
        backgroundView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func setupConstraints(){
        
        tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view)
            make.top.equalTo(mealNameLabel.snp.bottom).offset(50)
        }
        
        mealNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundView.customView).offset(17)
            make.leading.equalTo(backgroundView.customView).offset(29)
        }
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setupHeader() -> UIView{
        let headerView = UIView()
        let priceAndNumberLabel = UILabel()
        let customFont = UIFont(name: "Rubik-Bold", size: 14)
        
        priceAndNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        priceAndNumberLabel.numberOfLines = 2
        
        priceAndNumberLabel.font = customFont
        
        headerView.addSubview(priceAndNumberLabel)
        
        priceAndNumberLabel.text = "Naziv jela:"
        
        priceAndNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerView)
            make.leading.equalTo(headerView).offset(7)
            make.bottom.equalTo(headerView).offset(-20)
        }
        
        headerView.backgroundColor = .white
        return headerView
    }
    
    func setupData(){
        mealNameLabel.text = viewModel.returnLabelData(meal: viewModel.dependencies.mealCategory)
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
         print("vc deinited: ", self)
        childHasFinished?.viewControllerHasFinished()
     }
}

extension RestorauntMealTypesScreenController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dependencies.mealCategory.meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MTC", for: indexPath) as? MealTypeCell  else {
            fatalError("The dequeued cell is not an instance of RestorauntsTableViewCell.")
        }
        cell.setupCell(meal: viewModel.dependencies.mealCategory.meals[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.dependencies.mealCategory.meals
        didSelectMealName?.openNewCoordinator(meals: viewModel.didSelectRow(mealWithName: data, name: data[indexPath.row].name))
    }
    
}
