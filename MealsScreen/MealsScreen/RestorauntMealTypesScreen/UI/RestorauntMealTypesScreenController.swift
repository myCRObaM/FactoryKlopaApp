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
            }).disposed(by: disposeBag)
        
        viewModel.input.getData.onNext(true)
    }
    
    func setupView(){
        setupCollectionView()
        
        view.addSubview(backgroundImage)
        view.insertSubview(customView, aboveSubview: backgroundImage)
        view.insertSubview(tableView, aboveSubview: customView)
        view.backgroundColor = .white
        view.insertSubview(gradientBackground, belowSubview: backgroundImage)
        view.addSubview(backButton)
        
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        
    }
    
    func setupConstraints(){
        customView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view).inset(10)
            make.top.equalTo(view).inset(UIScreen.main.bounds.height/6)
        }
        
//        tableView.snp.makeConstraints { (make) in
//            make.bottom.leading.trailing.equalTo(view)
//            make.top.equalTo(customView).offset(40)
//        }
//        
//        gradientBackground.snp.makeConstraints { (make) in
//            make.top.equalTo(backgroundImage.snp.bottom)
//            make.bottom.equalTo(customView.snp.top).offset(20)
//            make.leading.trailing.equalTo(view)
//        }
        
        backgroundImage.snp.makeConstraints { (make) in
                   make.top.leading.trailing.equalTo(view)
                   make.height.equalTo(UIScreen.main.bounds.height/4.8)
               }
        
        backButton.snp.makeConstraints { (make) in
                   make.bottom.equalTo(customView.snp.top).offset(-10)
                   make.leading.equalTo(customView).offset(5)
                   make.height.width.equalTo(40)
               }
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: false)
    }
}
