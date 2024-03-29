//
//  SortedByNameTableViewCell.swift
//  MealsScreen
//
//  Created by Matej Hetzel on 19/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

public class SortedByNameTableViewCell: UITableViewCell {
    
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
    
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
            make.trailing.equalTo(contentView).inset(UIScreen.main.bounds.width/9.5)
            make.centerY.equalTo(contentView)
        }
        
        basketButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-8)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(ingredientsLabel)
        }
        
    }
    
    public func setupCell(name: MealsWithRestoraunt) {
        nameLabel.text = name.restorauntName
        
        if name.telLabel != "" {
            telLabel.text = name.telLabel!
        }
        if name.mobLabel != "" {
            mobLabel.text = name.mobLabel!
        }
        if name.ingredients?.count ?? 0 > 0 {
            var ingredients: String = ""
            for ingredient in name.ingredients! {
                if ingredients != "" {
                    ingredients = ingredients + ", " + ingredient.name!
                }
                else {
                    ingredients = ingredient.name!
                }
            }
            ingredients = "(" + ingredients + ")"
            self.ingredientsLabel.text = ingredients
        }
        priceLabel.text = name.price
    }
}
