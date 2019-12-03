//
//  WishListCell.swift
//  WishList
//
//  Created by Matej Hetzel on 27/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Shared

class WishListCell: UITableViewCell {
    let nameLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Regular", size: 14.0)
        view.font = customFont
        
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
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(priceLabel)
    }
    
    func setupConstraints(){
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(8)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-8)
        }
        ingredientsLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.centerX).offset(-UIScreen.main.bounds.width/10)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.trailing.equalTo(contentView.snp.centerX).offset(UIScreen.main.bounds.width/4)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
        }
        
        
    }
    
    public func setupCell(data: (String, String, String)) {
        nameLabel.text = data.0
        ingredientsLabel.text = data.1
        priceLabel.text = data.2
    }
    
    
    
}
