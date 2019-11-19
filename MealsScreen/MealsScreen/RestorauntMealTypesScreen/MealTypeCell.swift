//
//  MealTypeCell.swift
//  MealsScreen
//
//  Created by Matej Hetzel on 14/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Shared

class MealTypeCell: UITableViewCell {
    //MARK: UIElements
    let mealName: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Regular", size: 14.0)
        view.font = customFont
        view.numberOfLines = 2
        view.text = "mn"
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
    
    //MARK: Setup View
    func setupView(){
        contentView.addSubview(mealName)
    }
    //MARK: Setup constraints
    func setupConstraints(){
        mealName.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(7)
        }
    }
    //MARK: Setup cell
    func setupCell(meal: String){
        mealName.text = meal
    }
}
