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
import SnapKit

class SortedByNameVC: UIViewController {
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
        view.numberOfLines = 0
        return view
    }()
    
    let basketButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "addBasket"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: Variables
    let viewModel: SortedByMealNameModel
    let disposeBag = DisposeBag()
    let backgroundView = BackgroundView()
    weak var childHasFinished: CoordinatorDelegate?
    weak var basketButtonPress: CartButtonPressed?
    
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
        self.setupView()
        self.setupConstrints()
        setupViewModel()
    }
    
    //MARK: setupView
    func setupView(){
        view.addSubview(backgroundView)
        view.insertSubview(tableView, aboveSubview: backgroundView)
        view.insertSubview(mealNameLabel, aboveSubview: backgroundView)
        view.addSubview(basketButton)
        view.backgroundColor = .white
        
        tableView.register(SortedByNameTableViewCell.self, forCellReuseIdentifier: "MTC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        mealNameLabel.text = viewModel.dependencies.meals[0].name.uppercased()
        backgroundView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        basketButton.addTarget(self, action: #selector(openWishlistScreen), for: .touchUpInside)
    }
    
    func setupConstrints(){
        
        tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view)
            make.top.equalTo(mealNameLabel.snp.bottom).offset(50)
        }
        
        mealNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundView.customView).offset(17)
            make.leading.equalTo(backgroundView.customView).offset(29)
            make.trailing.equalTo(backgroundView.customView).offset(-29)
        }
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        basketButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(backgroundView.customView.snp.top).offset(5)
            make.trailing.equalTo(backgroundView.customView).offset(-5)
            make.height.width.equalTo(40)
        }
    }
    //MARK: Setup ViewModel
    func setupViewModel(){
        let input = SortedByMealNameModel.Input(getData: ReplaySubject<Bool>.create(bufferSize: 1), saveMeal: PublishSubject<SaveToListEnum>())
        let output = viewModel.transform(input: input)
        
        
        for disposable in output.disposables{
            disposable.disposed(by: disposeBag)
        }
        savedAlertHandler(subject: output.popupSubject).disposed(by: disposeBag)
        
        
        output.dataReady
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: { bool in
                
            }).disposed(by: disposeBag)
        
        output.errorSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: {[unowned self] bool in
                self.showPopUp()
            }).disposed(by: disposeBag)
        
        viewModel.input.getData.onNext(true)
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: false)
    }
    //MARK: Header
    
    func setupHeader() -> UIView{
        let bothViews = UIView()
        let views = setupNormalHeader()
        var pizzaView = UIView()
        
        
        
        
        views.backgroundColor = UIColor(red: 255/255.0, green: 184/255.0, blue: 14/255.0, alpha: 1)
        
        
        
        bothViews.addSubview(views)
        
        views.translatesAutoresizingMaskIntoConstraints = false
        
        
        views.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(bothViews)
        }
        switch viewModel.isPizza(meal: viewModel.dependencies.meals[0]) {
        case true:
            pizzaView = setupPizzaHeader()
            bothViews.addSubview(pizzaView)
            pizzaView.translatesAutoresizingMaskIntoConstraints = false
            pizzaView.backgroundColor = .white
            pizzaView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalTo(bothViews)
                make.top.equalTo(views.snp.bottom)
                make.height.equalTo(views)
            }
        default:
            views.snp.makeConstraints { (make) in
                make.bottom.equalTo(bothViews)
            }
            break
        }
        
        return bothViews
    }
    
    func setupNormalHeader() -> UIView {
        let mealLabel = UILabel()
        mealLabel.numberOfLines = 2
        let priceLabel = UILabel()
        let views = UIView()
        
        
        let customFont = UIFont(name: "Rubik-Black", size: 14)
        
        
        
        mealLabel.font = customFont
        priceLabel.font = customFont
        
        views.addSubview(mealLabel)
        views.addSubview(priceLabel)
        
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mealLabel.textColor = .black
        priceLabel.textColor = .black
        
        mealLabel.text = "Lokacija \n Kontakt"
        priceLabel.text = "Cijena"
        
        mealLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(views).inset(10)
            make.top.bottom.equalTo(views)
            make.height.equalTo(40)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(views).offset(-5)
            make.top.bottom.equalTo(views)
            make.height.equalTo(40)
        }
        
        return views
    }
    
    func setupPizzaHeader() -> UIView{
        let jnView = UIView()
        let jnLabel = UILabel()
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 2
        
        let customFont = UIFont(name: "Rubik-Bold", size: 12)
        
        jnLabel.translatesAutoresizingMaskIntoConstraints = false
        
        jnLabel.text = "J      N"
        jnLabel.font = customFont
        
        descriptionLabel.text = "*J - Jumbo pizza \n *N - Normalna pizza"
        descriptionLabel.font = customFont
        
        jnView.addSubview(descriptionLabel)
        jnView.addSubview(jnLabel)
        
        jnLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(jnView)
            make.trailing.equalTo(jnView).offset(-50)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(jnView)
            make.leading.equalTo(jnView).offset(10)
        }
        
        return jnView
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
    @objc func openWishlistScreen(){
        basketButtonPress?.openCart()
    }
    
    
    func savedAlertHandler(subject: PublishSubject<Bool>) -> Disposable{
        return subject
            .subscribeOn(viewModel.dependencies.scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (locations) in
                let viewForAlert = UIView()
                let labelText = UILabel()
                
                labelText.translatesAutoresizingMaskIntoConstraints = false
                viewForAlert.translatesAutoresizingMaskIntoConstraints = false
                labelText.text = "Dodano u WishList"
                let customFont = UIFont(name: "Rubik-Bold", size: 14)
                labelText.font = customFont
                
                viewForAlert.addSubview(labelText)
                self.view.addSubview(viewForAlert)
                
                labelText.snp.makeConstraints { (make) in
                    make.centerX.equalTo(viewForAlert)
                    make.centerY.equalTo(viewForAlert)
                    make.bottom.equalTo(viewForAlert).offset(-5)
                }
                viewForAlert.snp.makeConstraints { (make) in
                    make.bottom.leading.trailing.equalTo(self.view)
                    make.height.equalTo(50)
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    viewForAlert.removeFromSuperview()
                }
            })
        
        
        
    }
    
}


extension SortedByNameVC: UITableViewDelegate, UITableViewDataSource, ShopingCartButtonPress{
    func didPress(index: IndexPath) {
        switch viewModel.hasJumboPrice(price: viewModel.output.screenData!.data[index.row].priceJumbo ?? "") {
        case true:
            let alert = UIAlertController(title: "Zelite li Jumbo ili Normalnu", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Normalna", style: .default, handler: {[unowned self] action in
                self.viewModel.input.saveMeal.onNext(.normal(index))
            }))
            alert.addAction(UIAlertAction(title: "Jumbo", style: .default, handler: {[unowned self] action in
                self.viewModel.input.saveMeal.onNext(.jumbo(index))
            }))
            self.present(alert, animated: true)
            
        case false:
            viewModel.input.saveMeal.onNext(.normal(index))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output?.screenData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MTC", for: indexPath) as? SortedByNameTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RestorauntsTableViewCell.")
        }
        let data = viewModel.output?.screenData?.data[indexPath.row]
        cell.setupCell(data: data!, index: indexPath)
        cell.shoppingCartButton = self
        cell.separatorInset = .zero
        return cell
    }    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeader()
    }
}
