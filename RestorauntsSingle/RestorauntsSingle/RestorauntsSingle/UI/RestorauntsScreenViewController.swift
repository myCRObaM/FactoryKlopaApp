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
    
    let backButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "leftArrow"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gradientBackground: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    
    
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
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
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let input = RestorauntsSingleModel.Input(loadScreenData: ReplaySubject<Bool>.create(bufferSize: 1))
        
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
        
        expensionHandler(subject: output.expandableHandler).disposed(by: disposeBag)
        
        viewModel.input.loadScreenData.onNext(true)
    }
    //MARK: Setup View
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        view.insertSubview(customView, aboveSubview: backgroundImage)
        view.addSubview(tableView)
        view.insertSubview(gradientBackground, belowSubview: backgroundImage)
        view.addSubview(backButton)
        view.insertSubview(logoView, aboveSubview: backgroundImage)
        
        setupData()
    }
    //MARK: Setup data
    func setupData(){
        tableView.dataSource = self
        tableView.delegate = self
        
        backgroundImage.image = UIImage(named: "background")
        
        tableView.register(MealsTableViewCell.self, forCellReuseIdentifier: "asd")
        
        customView.nameLabel.text = viewModel.dependencies.meals.name
        customView.telLabel.text = viewModel.dependencies.meals.tel
        customView.mobLabel.text = viewModel.dependencies.meals.mob
        customView.wHoursLabel.text = viewModel.dependencies.meals.workingHours
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        customView.detailsButton.addTarget(self, action: #selector(aboutUsButtonPressed), for: .touchUpInside)
        
        customView.priceButton.addTarget(self, action: #selector(pricesButtonPressed), for: .touchUpInside)
        
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
        backgroundImage.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(UIScreen.main.bounds.height/4.8)
        }
        
        gradientBackground.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage.snp.bottom)
            make.bottom.equalTo(tableView.snp.top).offset(-UIScreen.main.bounds.height/6)
            make.leading.trailing.equalTo(view)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(customView.snp.top).offset(5)
            make.leading.equalTo(customView).offset(-5)
            make.height.width.equalTo(40)
        }
        logoView.snp.makeConstraints { (make) in
            make.leading.equalTo(customView).offset(30)
            make.bottom.equalTo(customView.snp.top).offset(-30)
            make.width.equalTo(175)
            make.height.equalTo(48)
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
            switch viewModel.isButtonSelected(section: section) {
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
        expandButton.isSelected = viewModel.isButtonSelected(section: section)
        
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
        
        customView.detailsButton.isSelected = true
        customView.priceButton.isSelected = false
    }
    
    @objc func pricesButtonPressed(){
        aboutUs.removeFromSuperview()
        
        customView.detailsButton.isSelected = false
        customView.priceButton.isSelected = true
    }
    
}

//MARK: TableView delegates
extension RestorauntsScreenViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.setupCell(meal: viewModel.dependencies.meals.meals[indexPath.section].meals[indexPath.row])
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
