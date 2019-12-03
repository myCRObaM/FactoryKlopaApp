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
        let input = RestorauntsSingleModel.Input(loadScreenData: ReplaySubject<Bool>.create(bufferSize: 1), saveMeal: PublishSubject<SaveToListEnum>(), screenSelectionButtonSubject: PublishSubject<Bool>())
        
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        
        output.dataReady
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: {[unowned self] bool in
                self.setupData()
                self.pricesButtonPressed()
            }).disposed(by: disposeBag)
        
        output.errorSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: {[unowned self] bool in
                self.showPopUp()
            }).disposed(by: disposeBag)
        
        expensionHandler(subject: output.expandableHandler).disposed(by: disposeBag)
        savedAlertHandler(subject: output.popupSubject).disposed(by: disposeBag)
        setupButtons(subject: output.buttonStateSubject).disposed(by: disposeBag)
        
        viewModel.input.loadScreenData.onNext(true)
    }
    //MARK: Setup View
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        view.insertSubview(customView, aboveSubview: backgroundView)
        view.addSubview(tableView)
        view.addSubview(basketButton)
    }
    //MARK: Setup data
    func setupData(){
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.register(MealsTableViewCell.self, forCellReuseIdentifier: "asd")
        guard let data = viewModel.output?.screenData else {
            return
        }
        customView.nameLabel.text = data.title
        customView.telLabel.text = data.tel
        customView.mobLabel.text = data.mob
        customView.wHoursLabel.text = data.workingHours
        
        backgroundView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        customView.detailsButton.addTarget(self, action: #selector(aboutUsButtonPressed), for: .touchUpInside)
        
        customView.priceButton.addTarget(self, action: #selector(pricesButtonPressed), for: .touchUpInside)
        
        basketButton.addTarget(self, action: #selector(openWishlistScreen), for: .touchUpInside)
    }
    //MARK: Constraints setup
    func setupConstraints(){
        customView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view).inset(10)
            make.top.equalTo(view).inset(UIScreen.main.bounds.height/6)
        }
        tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view)
            make.top.equalTo(customView.priceButton.snp.bottom).offset(30)
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
        
        views.backgroundColor = UIColor.init(named: "headerBackground")
        bothViews.addSubview(views)
        
        views.translatesAutoresizingMaskIntoConstraints = false
        
        views.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(bothViews)
        }
        switch viewModel.isPizza(category: category) {
        case true:
            switch !viewModel.isCollapsed(section: viewModel.output.screenData.section[section]) {
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
        expandButton.isSelected = !viewModel.isCollapsed(section: viewModel.output.screenData.section[section])
        
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
        priceLabel.text = NSLocalizedString("price", comment: "")
        
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
        
        descriptionLabel.text = NSLocalizedString("jmboNormal", comment: "")
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
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: { [unowned self] bool in
                self.tableView.reloadData()
            })
    }
    //MARK: Button action
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func expandableButtonPressed(button: UIButton){
        viewModel.expandableHandler(section: button.tag, data: viewModel.dependencies.meals.meals[button.tag].meals)
        button.isSelected = !button.isSelected
        view.updateConstraints()
    }
    
    @objc func aboutUsButtonPressed(){
        view.insertSubview(aboutUs, aboveSubview: tableView)
        
        aboutUs.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView)
        }
        viewModel.input.screenSelectionButtonSubject.onNext(true)
    }
    
    @objc func pricesButtonPressed(){
        aboutUs.removeFromSuperview()
        viewModel.input.screenSelectionButtonSubject.onNext(false)
    }
    
    @objc func openWishlistScreen(){
        basketButtonPress?.openCart()
    }
    
    //MARK Button setup
    func setupButtons(subject: PublishSubject<Bool>) -> Disposable{
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: {[unowned self] bool in
            self.customView.detailsButton.isSelected = bool
            self.customView.priceButton.isSelected = !bool
        })
        
    }
    //MARK: popUp function
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
    
    
    //MARK: Save alert
    func savedAlertHandler(subject: PublishSubject<Bool>) -> Disposable{
        return subject
            .subscribeOn(viewModel.dependencies.scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (locations) in
                let viewForAlert = UIView()
                let labelText = UILabel()
                
                labelText.translatesAutoresizingMaskIntoConstraints = false
                viewForAlert.translatesAutoresizingMaskIntoConstraints = false
                labelText.text = NSLocalizedString("wishListAdd", comment: "")
                let customFont = UIFont(name: "Rubik-Bold", size: 16)
                labelText.font = customFont
                
                viewForAlert.addSubview(labelText)
                viewForAlert.backgroundColor = .white
                self.view.addSubview(viewForAlert)
                
                labelText.snp.makeConstraints { (make) in
                    make.centerX.equalTo(viewForAlert)
                    make.centerY.equalTo(viewForAlert)
                    make.top.equalTo(viewForAlert).offset(5)
                }
                viewForAlert.snp.makeConstraints { (make) in
                    make.bottom.leading.trailing.equalTo(self.view)
                    make.height.equalTo(100)
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    viewForAlert.removeFromSuperview()
                }
            })
    }
}

//MARK: TableView delegates
extension RestorauntsScreenViewController: UITableViewDelegate, UITableViewDataSource, ShopingCartButtonPress {
    func didPress(index: IndexPath) {
        
        switch viewModel.hasJumboPrice(price: viewModel.dependencies.meals.meals[index.section].meals[index.row].priceJumbo ?? "") {
        case true:
            let alert = UIAlertController(title: NSLocalizedString("pizzaSelectionTitle", comment: ""), message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("normalPizzaSelection", comment: ""), style: .default, handler: {[unowned self] action in
                self.viewModel.input.saveMeal.onNext(.normal(index))
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("jumboPizzaSelection", comment: ""), style: .default, handler: {[unowned self] action in
                self.viewModel.input.saveMeal.onNext(.jumbo(index))
            }))
            self.present(alert, animated: true)
            
        case false:
            viewModel.input.saveMeal.onNext(.normal(index))
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeader(category: viewModel.returnHeaderName(meal: viewModel.dependencies.meals.meals[section]), section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output?.screenData?.section.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = viewModel.output?.screenData?.section[section]
        return data?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "asd", for: indexPath) as? MealsTableViewCell  else {
            fatalError(NSLocalizedString("cell_Error", comment: ""))
        }
        let data = viewModel.output.screenData!.section[indexPath.section].data[indexPath.row]
        cell.setupCell(data: viewModel.setupCellData(data: data), indexPath: indexPath)
        cell.shoppingCartButton = self
        cell.backgroundColor = .white
        cell.selectionStyle = .none
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
