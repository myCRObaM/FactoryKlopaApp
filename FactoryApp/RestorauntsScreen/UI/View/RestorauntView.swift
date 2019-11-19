//
//  RestorauntView.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 12/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

class RestorauntView: UIView {
    let restorauntsButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont(name: "Rubik-Regular", size: 17)
        view.setAttributedTitle(NSAttributedString(string: "Restorani", attributes:
        [.underlineStyle: NSUnderlineStyle.thick.rawValue, .underlineColor: UIColor(red: 255/255.0, green: 184/255.0, blue: 14/255.0, alpha: 1)]), for: .selected)
        view.setAttributedTitle(NSAttributedString(string: "Restorani"), for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = customFont
        return view
    }()
    
    let mealsButton: UIButton = {
           let view = UIButton()
           view.translatesAutoresizingMaskIntoConstraints = false
           let customFont = UIFont(name: "Rubik-Regular", size: 17)
           view.setAttributedTitle(NSAttributedString(string: "Jela"), for: .normal)
        
        view.setAttributedTitle(NSAttributedString(string: "Jela", attributes:
            [.underlineStyle: NSUnderlineStyle.thick.rawValue, .underlineColor: UIColor(red: 255/255.0, green: 184/255.0, blue: 14/255.0, alpha: 1)]), for: .selected)
           view.setTitleColor(.black, for: .normal)
           view.titleLabel?.font = customFont
           return view
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(restorauntsButton)
        self.addSubview(mealsButton)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        restorauntsButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(25).priority(.required)
            make.leading.equalTo(self).offset(30)
        }
        
        mealsButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(25)
            make.leading.equalTo(restorauntsButton.snp.trailing).offset(30)
        }
    }
}
