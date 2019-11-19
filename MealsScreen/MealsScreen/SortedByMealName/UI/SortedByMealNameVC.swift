//
//  SortedByMealNameVC.swift
//  MealsScreen
//
//  Created by Matej Hetzel on 19/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Shared
import RxSwift

class SortedByNameVC: UIViewController {
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
        view.numberOfLines = 0
        return view
    }()
    
    let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    //MARK: Variables
    let viewModel: SortedByMealNameModel
    let disposeBag = DisposeBag()
    
    //MARK: Init
    init(viewModel: SortedByMealNameModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    //MARK: setupView
    func setupView(){
        view.addSubview(backgroundImage)
        view.insertSubview(customView, aboveSubview: backgroundImage)
        view.insertSubview(tableView, aboveSubview: customView)
        view.backgroundColor = .white
        view.insertSubview(gradientBackground, belowSubview: backgroundImage)
        view.addSubview(backButton)
        view.insertSubview(mealNameLabel, aboveSubview: customView)
        view.insertSubview(logoView, aboveSubview: backgroundImage)
        
        tableView.register(SortedByNameTableViewCell.self, forCellReuseIdentifier: "MTC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        mealNameLabel.text = viewModel.dependencies.meals[0].name.uppercased()
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func setupConstrints(){
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
                   make.bottom.equalTo(customView.snp.top).offset(-5)
                   make.leading.equalTo(customView).offset(5)
                   make.height.width.equalTo(40)
               }
        
        mealNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(customView).offset(17)
            make.leading.equalTo(customView).offset(29)
            make.trailing.equalTo(customView).offset(-29)
        }
        
        logoView.snp.makeConstraints { (make) in
            make.leading.equalTo(customView).offset(30)
            make.bottom.equalTo(customView.snp.top).offset(-30)
            make.width.equalTo(175)
            make.height.equalTo(48)
        }
    }
    //MARK: Setup ViewModel
    func setupViewModel(){
        let input = SortedByMealNameModel.Input(getData: ReplaySubject<Bool>.create(bufferSize: 1))
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables{
            disposable.disposed(by: disposeBag)
        }
        
        output.dataReady
        .observeOn(MainScheduler.instance)
        .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
            self.setupView()
            self.setupConstrints()
        }).disposed(by: disposeBag)
        
        viewModel.input.getData.onNext(true)
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: false)
     }
    //MARK: Header
    func setupHeader() -> UIView{
        let header = UIView()
        let restorauntLabel = UILabel()
        let contactLabel = UILabel()
        let ingredientsLabel = UILabel()
        let priceLabel = UILabel()
        
        let customFont = UIFont(name: "Rubik-Bold", size: 14.0)
        header.backgroundColor = .white
        
        restorauntLabel.translatesAutoresizingMaskIntoConstraints = false
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        restorauntLabel.text = "Lokacija"
        restorauntLabel.font = customFont
        
        contactLabel.text = "Tel/Mob"
        contactLabel.font = customFont
        
        
        ingredientsLabel.text = "Sastojci"
        ingredientsLabel.font = customFont
        
        priceLabel.text = "Cijena"
        priceLabel.font = customFont
        
        header.addSubview(restorauntLabel)
        header.addSubview(contactLabel)
        header.addSubview(ingredientsLabel)
        header.addSubview(priceLabel)
        
        
        restorauntLabel.snp.makeConstraints { (make) in
            make.top.equalTo(header).offset(5)
            make.leading.equalTo(header).offset(5)
        }
        
        contactLabel.snp.makeConstraints { (make) in
            make.top.equalTo(restorauntLabel.snp.bottom).offset(3)
            make.leading.equalTo(header).offset(5)
            make.bottom.equalTo(header).offset(-5)
        }
        
        ingredientsLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(header)
            make.top.equalTo(header).offset(5)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(header).offset(-5)
            make.top.equalTo(header).offset(5)
        }
        
        
        
        return header
    }
    
}

 
extension SortedByNameVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dependencies.meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "MTC", for: indexPath) as? SortedByNameTableViewCell  else {
                   fatalError("The dequeued cell is not an instance of RestorauntsTableViewCell.")
        }
        cell.setupCell(name: viewModel.dependencies.meals[indexPath.row])
        return cell
    }    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeader()
    }
}
