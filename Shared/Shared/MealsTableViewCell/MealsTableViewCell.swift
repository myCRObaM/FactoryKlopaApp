//
//  MealsTableViewCell.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 06/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit


public class MealsTableViewCell: UITableViewCell {
    //MARK: Views
    public weak var shoppingCartButton: ShopingCartButtonPress?
    var index: IndexPath!
    
    let pricesLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Bold", size: 14.0)
        view.font = customFont
        view.text = "pl"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mealName: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Bold", size: 14.0)
        view.font = customFont
        view.numberOfLines = 2
        view.text = "mn"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ingredientsLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Italic", size: 14)
        view.font = customFont
        view.text = ""
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 3
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    let basketButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "addBasket"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: init
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: ViewSetup
    func setupView(){
        contentView.addSubview(pricesLabel)
        contentView.addSubview(mealName)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(basketButton)
    }
    
    func setupConstraints(){
        pricesLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).inset(UIScreen.main.bounds.width/8.3)
            make.centerY.equalTo(basketButton)
        }
        
        mealName.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(5)
            make.leading.equalTo(contentView).inset(10)
            make.trailing.equalTo(contentView).offset(-80)
        }
        
        ingredientsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mealName.snp.bottom).offset(2)
            make.bottom.equalTo(contentView).offset(-5)
            make.leading.equalTo(contentView).inset(10)
            make.trailing.equalTo(pricesLabel.snp.leading).offset(-30)
        }
        
        basketButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-8)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(ingredientsLabel)
        }
        
    }
    
    //MARK: Cell setup
    public func setupCell(meal: Meals, indexPath: IndexPath){
        var ingredients: String = ""
        index = indexPath
        mealName.text = meal.name.uppercased()
        pricesLabel.text = meal.price
        if meal.ingredients?.count ?? 0 > 0 {
            for ingredient in meal.ingredients! {
                if ingredients != "" {
                    ingredients = ingredients + ", " + ingredient.name!
                }
                else {
                    ingredients = ingredient.name!
                }
                
            }
            ingredients = "(" + ingredients + ")"
            ingredientsLabel.text = ingredients
        }
        
        if Int(meal.priceJumbo ?? "0") ?? 0 > 0 {
            pricesLabel.text = (meal.priceNormal ?? "") + "  " + (meal.priceJumbo ?? "")
        }
        
        contentView.updateConstraints()
        basketButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
    }
    
    @objc func buttonPressed(){
        shoppingCartButton?.didPress(index: index)
    }
}
