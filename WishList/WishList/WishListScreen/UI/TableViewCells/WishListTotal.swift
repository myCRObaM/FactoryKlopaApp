//
//  WishListTotal.swift
//  WishList
//
//  Created by Matej Hetzel on 28/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
class WishListTotal: UITableViewCell {
    
    let totalLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Total amount: "
        let customFont = UIFont(name: "Rubik-Bold", size: 14.0)
        view.font = customFont
        return view
    }()
    
    let totalAmountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "22"
        let customFont = UIFont(name: "Rubik-Bold", size: 14.0)
        view.font = customFont
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
    
    
    func setupView(){
        contentView.addSubview(totalLabel)
        contentView.addSubview(totalAmountLabel)
    }
    
    func setupConstraints(){
        totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.leading.equalTo(contentView).offset(10)
        }
        
        totalAmountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-10)
        }
    }
    
    func setupCell(ammount: Int){
        totalAmountLabel.text = String(ammount)
    }
}
