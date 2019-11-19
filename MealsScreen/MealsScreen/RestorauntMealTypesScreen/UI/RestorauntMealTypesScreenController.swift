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

class RestorauntMealTypesScreenController: UIViewController {
    //MARK: ViewElements
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "background")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let gradientBackground: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let backButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "leftArrow"), for: .normal)
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
    
    let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
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
    weak var didSelectMealName: didSelectMealName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
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
            .subscribe(onNext: { [unowned self] bool in
                self.setupView()
                self.setupConstraints()
                self.setupData()
            }).disposed(by: disposeBag)
        
        viewModel.input.getData.onNext(true)
    }
    
    func setupView(){        
        view.addSubview(backgroundImage)
        view.insertSubview(customView, aboveSubview: backgroundImage)
        view.insertSubview(tableView, aboveSubview: customView)
        view.backgroundColor = .white
        view.insertSubview(gradientBackground, belowSubview: backgroundImage)
        view.addSubview(backButton)
        view.insertSubview(mealNameLabel, aboveSubview: customView)
        view.insertSubview(logoView, aboveSubview: backgroundImage)
        
        tableView.register(MealTypeCell.self, forCellReuseIdentifier: "MTC")
        tableView.delegate = self
        tableView.dataSource = self
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func setupConstraints(){
        customView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view).inset(10)
            make.top.equalTo(view).inset(UIScreen.main.bounds.height/6)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view)
            make.top.equalTo(mealNameLabel.snp.bottom).offset(50)
        }
        
        gradientBackground.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage.snp.bottom)
            make.bottom.equalTo(backgroundImage.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view)
        }
        
        backgroundImage.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(UIScreen.main.bounds.height/4.8)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(customView.snp.top).offset(5)
            make.leading.equalTo(customView).offset(-5)
            make.height.width.equalTo(40)
        }
        
        mealNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(customView).offset(17)
            make.leading.equalTo(customView).offset(29)
        }
        
        logoView.snp.makeConstraints { (make) in
            make.leading.equalTo(customView).offset(30)
            make.bottom.equalTo(customView.snp.top).offset(-30)
            make.width.equalTo(175)
            make.height.equalTo(48)
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
