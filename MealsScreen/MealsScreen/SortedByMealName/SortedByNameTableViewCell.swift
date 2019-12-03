//
//  SortedByNameTableViewCell.swift
//  MealsScreen
//
//  Created by Matej Hetzel on 19/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Shared

class SortedByNameTableViewCell: UITableViewCell {
    
    
    public weak var shoppingCartButton: ShopingCartButtonPress?
    var index: IndexPath!
    
    let nameLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Regular", size: 14.0)
        view.font = customFont
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let telLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Regular", size: 14.0)
        view.font = customFont
        view.textColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mobLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Regular", size: 14.0)
        view.font = customFont
        view.textColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ingredientsLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Italic", size: 14.0)
        view.font = customFont
        view.textColor = .darkGray
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let priceLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Regular", size: 14.0)
        view.font = customFont
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let basketButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "addBasket"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(telLabel)
        contentView.addSubview(mobLabel)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(basketButton)
    }
    
    func setupConstraints(){
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(8)
            make.top.equalTo(contentView).offset(5)
        }
        mobLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(8)
            make.top.equalTo(telLabel.snp.bottom).offset(3)
            make.bottom.equalTo(contentView).offset(-5)
        }
        telLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(contentView).offset(8)
        }
        ingredientsLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.centerX).offset(-UIScreen.main.bounds.width/10)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.trailing.equalTo(contentView.snp.centerX).offset(UIScreen.main.bounds.width/4)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).inset(UIScreen.main.bounds.width/8.3)
            make.centerY.equalTo(contentView)
        }
        
        basketButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-8)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(ingredientsLabel)
        }
        
    }
    
    func setupCell(data: Rows, index: IndexPath) {
        self.index = index
        nameLabel.text = data.restorauntName
        mobLabel.text = data.mob
        telLabel.text = data.tel
        ingredientsLabel.text = data.ingredients
        if data.priceJumbo != nil {
            priceLabel.text = ((data.priceJumbo ?? "") + "  " + (data.priceNormal ?? ""))
        }
        else {
            priceLabel.text = data.price ?? ""
        }
        
        basketButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
    }
    @objc func buttonPressed(){
        shoppingCartButton?.didPress(index: index)
    }
    
    
}
