//
//  MealsCustomView.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 06/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit


class RestorauntsView: UIView {
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont(name: "Rubik-Medium", size: 28.51)
        view.font = customFont
        view.text = ""
        return view
    }()
    
    let contactImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "Contact")
        return view
    }()
    
    let telLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Regular", size: 14)
        view.font = customFont
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        return view
    }()
    
    let mobLabel: UILabel = {
        let view = UILabel()
        let customFont = UIFont(name: "Rubik-Regular", size: 14)
        view.font = customFont
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        return view
    }()
    
    let wHoursLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.text = ""
        let customFont = UIFont(name: "Rubik-Regular", size: 14)
        view.font = customFont
        return view
    }()
    
    let wHoursImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "Time")
        return view
    }()
    
    let priceButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont(name: "Rubik-Regular", size: 17)
        view.setAttributedTitle(NSAttributedString(string: "Cjenik", attributes:
        [.underlineStyle: NSUnderlineStyle.thick.rawValue, .underlineColor: UIColor(red: 255/255.0, green: 184/255.0, blue: 14/255.0, alpha: 1)]), for: .selected)
        view.setAttributedTitle(NSAttributedString(string: "Cjenik"), for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = customFont
        return view
    }()
    
    let detailsButton: UIButton = {
           let view = UIButton()
           view.translatesAutoresizingMaskIntoConstraints = false
           let customFont = UIFont(name: "Rubik-Regular", size: 17)
           view.setAttributedTitle(NSAttributedString(string: "O nama"), for: .normal)
        
        view.setAttributedTitle(NSAttributedString(string: "O nama", attributes:
            [.underlineStyle: NSUnderlineStyle.thick.rawValue, .underlineColor: UIColor(red: 255/255.0, green: 184/255.0, blue: 14/255.0, alpha: 1)]), for: .selected)
           view.setTitleColor(.black, for: .normal)
           view.titleLabel?.font = customFont
           return view
       }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(nameLabel)
        self.addSubview(telLabel)
        self.addSubview(mobLabel)
        self.addSubview(wHoursLabel)
        self.addSubview(contactImageView)
        self.addSubview(wHoursImageView)
        self.addSubview(priceButton)
        self.addSubview(detailsButton)
    }
    
    func setupConstraints(){
        nameLabel.snp.makeConstraints { (make) in
            make.leading.top.equalTo(self).offset(30)
        }
        
        telLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contactImageView.snp.trailing).offset(10)
            make.centerY.equalTo(contactImageView)
        }
        
        mobLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(telLabel.snp.trailing).offset(10)
            make.centerY.equalTo(telLabel)
        }
        wHoursLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(wHoursImageView)
            make.leading.equalTo(wHoursImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self).offset(-30)
        }
        
        contactImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(30)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.height.width.equalTo(24)
        }
        wHoursImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(30)
            make.top.equalTo(contactImageView.snp.bottom).offset(13)
            make.height.width.equalTo(24)
        }
        
        priceButton.snp.makeConstraints { (make) in
            make.top.equalTo(wHoursImageView.snp.bottom).offset(20)
            make.leading.equalTo(wHoursImageView)
        }
        
        detailsButton.snp.makeConstraints { (make) in
            make.top.equalTo(wHoursImageView.snp.bottom).offset(20)
            make.leading.equalTo(priceButton.snp.trailing).offset(30)
        }
    }
}
