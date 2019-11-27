//
//  MealsScreenViewController.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 31/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit
import Shared

class RestorauntsScreenViewController: UIViewController {
    
    //MARK: ViewElements
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let aboutUs: AboutUsScreen = {
        let view = AboutUsScreen()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let basketButton: UIButton = {
           let view = UIButton()
           view.setImage(UIImage(named: "addBasket"), for: .normal)
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
    
    
    let customView: RestorauntsView = {
        let view = RestorauntsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: Variables
    let viewModel: RestorauntsSingleModel
    let disposeBag = DisposeBag()
    let backgroundView = BackgroundView()
    weak var basketButtonPress: CartButtonPressed?
    
    weak var childHasFinished: CoordinatorDelegate?
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
        prepareViewModel()
    }
    
    //MARK: Init
    
    init(viewModel: RestorauntsSingleModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: ViewModel Setup
    func prepareViewModel(){
        let input = RestorauntsSingleModel.Input(loadScreenData: ReplaySubject<Bool>.create(bufferSize: 1), saveMeal: PublishSubject<IndexPath>())
        
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        
        output.dataReady
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: {bool in

            }).disposed(by: disposeBag)
        
        output.errorSubject
        .observeOn(MainScheduler.instance)
        .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: {[unowned self] bool in
            self.showPopUp()
        }).disposed(by: disposeBag)
        
        expensionHandler(subject: output.expandableHandler).disposed(by: disposeBag)
        
        viewModel.input.loadScreenData.onNext(true)
    }
    //MARK: Setup View
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        view.insertSubview(customView, aboveSubview: backgroundView)
        view.addSubview(tableView)
        view.addSubview(basketButton)
        
        setupData()
    }
    //MARK: Setup data
    func setupData(){
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.register(MealsTableViewCell.self, forCellReuseIdentifier: "asd")
        
        customView.nameLabel.text = viewModel.dependencies.meals.name
        customView.telLabel.text = viewModel.dependencies.meals.tel
        customView.mobLabel.text = viewModel.dependencies.meals.mob
        customView.wHoursLabel.text = viewModel.dependencies.meals.workingHours
        
        backgroundView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        customView.detailsButton.addTarget(self, action: #selector(aboutUsButtonPressed), for: .touchUpInside)
        
        customView.priceButton.addTarget(self, action: #selector(pricesButtonPressed), for: .touchUpInside)
        
        basketButton.addTarget(self, action: #selector(openWishlistScreen), for: .touchUpInside)
        
        pricesButtonPressed()
    }
    //MARK: Constraints setup
    func setupConstraints(){
        customView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view).inset(10)
            make.top.equalTo(view).inset(UIScreen.main.bounds.height/6)
        }
        tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view)
            make.top.equalTo(customView.priceButton.snp.bottom).offset(34)
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
    //MARK: Header setup
    func setupHeader(category: String, _ section: Int) -> UIView{
        let bothViews = UIView()
        let views = setupNormalHeader(category: category, section)
        var pizzaView = UIView()
        
        
        
        
        views.backgroundColor = UIColor(red: 255/255.0, green: 184/255.0, blue: 14/255.0, alpha: 1)
        
        
        
        bothViews.addSubview(views)
        
        views.translatesAutoresizingMaskIntoConstraints = false
        
        
        views.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(bothViews)
        }
        switch viewModel.isPizza(category: category) {
        case true:
            switch viewModel.isCollapsed(section: section) {
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
            case false:
                views.snp.makeConstraints { (make) in
                    make.bottom.equalTo(bothViews)
                }
            }
        default:
            views.snp.makeConstraints { (make) in
                make.bottom.equalTo(bothViews)
            }
            break
        }
        
        return bothViews
    }
    
    func setupNormalHeader(category: String, _ section: Int) -> UIView {
        let mealLabel = UILabel()
        let priceLabel = UILabel()
        let views = UIView()
        
        let expandButton = UIButton()
        
        expandButton.setImage(UIImage(named: "expand"), for: .normal)
        expandButton.setImage(UIImage(named: "collapse"), for: .selected)
        
        expandButton.addTarget(self, action: #selector(expandableButtonPressed), for: .touchUpInside)
        expandButton.tag = section
        expandButton.isSelected = viewModel.isCollapsed(section: section)
        
        let customFont = UIFont(name: "Rubik-Black", size: 14)
        
        
        
        mealLabel.font = customFont
        priceLabel.font = customFont
        
        views.addSubview(mealLabel)
        views.addSubview(priceLabel)
        views.addSubview(expandButton)
        
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        
        mealLabel.textColor = .black
        priceLabel.textColor = .black
        
        mealLabel.text = category.uppercased()
        priceLabel.text = "Cijena"
        
        mealLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(views).inset(10)
            make.top.bottom.equalTo(views)
            make.height.equalTo(40)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(expandButton.snp.leading).offset(-5)
            make.top.bottom.equalTo(views)
            make.height.equalTo(40)
        }
        expandButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(views)
            make.top.bottom.equalTo(views)
            make.height.width.equalTo(40)
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
    
    //MARK: Expension handler
    func expensionHandler(subject: PublishSubject<ExpansionEnum>) -> Disposable {
        subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: { [unowned self] bool in
                switch bool {
                case .expand(let indexpath):
                    self.tableView.insertRows(at: indexpath, with: .automatic)
                    self.tableView.reloadSections(IndexSet(arrayLiteral: indexpath[0].section), with: .none)
                    
                case .colapse(let indexpath):
                    self.tableView.deleteRows(at: indexpath, with: .automatic)
                    self.tableView.reloadSections(IndexSet(arrayLiteral: indexpath[0].section), with: .none)
                    
                }
                self.view.updateConstraints()
            })
        
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func expandableButtonPressed(button: UIButton){
        viewModel.expandableHandler(section: button.tag)
        button.isSelected = !button.isSelected
        view.updateConstraints()
        
    }
    
    @objc func aboutUsButtonPressed(){
        view.insertSubview(aboutUs, aboveSubview: tableView)
        
        aboutUs.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView)
        }
        setupButtons(selection: viewModel.detailsButtonSelected(bool: true))
    }
    
    @objc func pricesButtonPressed(){
        aboutUs.removeFromSuperview()
        setupButtons(selection: viewModel.detailsButtonSelected(bool: false))
    }
    
    func setupButtons(selection: (Bool, Bool)){
        customView.detailsButton.isSelected = selection.0
        customView.priceButton.isSelected = selection.1
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
}

//MARK: TableView delegates
extension RestorauntsScreenViewController: UITableViewDelegate, UITableViewDataSource, ShopingCartButtonPress {
    func didPress(index: IndexPath) {
        viewModel.input.saveMeal.onNext(index)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeader(category: viewModel.returnHeaderName(meal: viewModel.dependencies.meals.meals[section]), section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dependencies.meals.meals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "asd", for: indexPath) as? MealsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RestorauntsTableViewCell.")
        }
        cell.setupCell(meal: viewModel.dependencies.meals.meals[indexPath.section].meals[indexPath.row], indexPath: indexPath)
        cell.shoppingCartButton = self
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let customFooterView = UIView()
        
        
        customFooterView.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(customFooterView)
        customFooterView.backgroundColor = .white
        
        customFooterView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(footerView)
            make.height.equalTo(10)
        }
        
        return footerView
    }
}
