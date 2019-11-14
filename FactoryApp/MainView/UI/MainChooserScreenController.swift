//
//  ViewController.swift
//  KlopaFactory
//
//  Created by Matej Hetzel on 21/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import SnapKit
import Shared
import RxSwift

class MainChooserScreenController: UIViewController {
    
    //MARK: View
    let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let newOrderButton: PaddingLabel = {
        let view = PaddingLabel()
        view.text = "Nova naruđba"
        view.textColor = .gray
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.layer.masksToBounds = true
        return view
    }()
    
    let historyOrderButton: PaddingLabel = {
        let view = PaddingLabel()
        view.text = "Naruci prosle narudbe"
        view.textColor = .gray
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.layer.masksToBounds = true
        return view
    }()
    
    //MARK: Variables
    let viewModel: MainScreenViewModel!
    let disposeBag = DisposeBag()
    weak var newScreenDelegate: NewOrderScreenDelegate?
    
    
    //MARK: Init
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        // Do any additional setup after loading the view.
    }
    
    //MARK: SetupViewModel
    func setupViewModel() {
        let newOrder = UITapGestureRecognizer(target: self, action: #selector(openNewOrderScreen))
        newOrderButton.addGestureRecognizer(newOrder)
        
        let input = MainScreenViewModel.Input(startLoadingScreen: ReplaySubject<Bool>.create(bufferSize: 1))
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        
        output.viewModelDone
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: { [unowned self] bool in
                self.setupView()
                self.setupConstraints()
                }, onError: { bool in
                    output.errorPopup.onNext(true)
            }
        ).disposed(by: disposeBag)
        
        viewModel.input?.startLoadingScreen.onNext(true)
    }
    //MARK: SetupView
    func setupView(){
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(customView)
        view.addSubview(newOrderButton)
        view.addSubview(historyOrderButton)
        
    }
    //MARK: SetupConstraints
    func setupConstraints() {
        customView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        newOrderButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(UIScreen.main.bounds.height/4)
        }
        
        historyOrderButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(newOrderButton).offset(UIScreen.main.bounds.height/12)
        }
    }
    
    @objc func openNewOrderScreen() {
        newScreenDelegate?.openNewOrder()
    }
    
    
}

extension MainChooserScreenController {
    @IBDesignable class PaddingLabel: UILabel {
        @IBInspectable var topInset: CGFloat = 10.0
        @IBInspectable var bottomInset: CGFloat = 5.0
        @IBInspectable var leftInset: CGFloat = 25.0
        @IBInspectable var rightInset: CGFloat = 25.0
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + leftInset + rightInset,
                          height: size.height + topInset + bottomInset)
        }
    }
}

