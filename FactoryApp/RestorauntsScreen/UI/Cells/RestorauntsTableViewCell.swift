//
//  RestorauntsTableViewCell.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Shared

class RestorauntsTableViewCell: UITableViewCell {
    
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mobLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Regular", size: 14.0)
        view.font = customFont
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
    }
    
    func setupConstraints(){
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(8)
        }
        mobLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalTo(telLabel.snp.leading).offset(-15)
        }
        telLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-8)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    func setupCell(name: String, tel: String, mob: String) {
        nameLabel.text = name
        
        if tel != "" {
            telLabel.text = tel
        }
        if mob != "" {
            mobLabel.text = mob
        }
        
    }
}
