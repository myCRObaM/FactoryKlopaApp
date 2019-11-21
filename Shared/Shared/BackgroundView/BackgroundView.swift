//
//  BackgroundView.swift
//  Shared
//
//  Created by Matej Hetzel on 21/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class BackgroundView: UIView {
    //MARK: ViewElements
    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "background")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let gradientBackground: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    public let backButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "leftArrow"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(backgroundImage)
        self.insertSubview(customView, aboveSubview: backgroundImage)
        self.backgroundColor = .white
        self.insertSubview(gradientBackground, belowSubview: backgroundImage)
        self.addSubview(backButton)
        self.insertSubview(logoView, aboveSubview: backgroundImage)
    }
    
    func setupConstraints(){
        customView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self).inset(10)
            make.top.equalTo(self).inset(UIScreen.main.bounds.height/6)
        }
        
        
        gradientBackground.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImage.snp.bottom)
            make.bottom.equalTo(backgroundImage.snp.bottom).offset(40)
            make.leading.trailing.equalTo(self)
        }
        
        backgroundImage.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(UIScreen.main.bounds.height/4.8)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(customView.snp.top).offset(5)
            make.leading.equalTo(customView).offset(-5)
            make.height.width.equalTo(40)
        }
        
        logoView.snp.makeConstraints { (make) in
            make.leading.equalTo(customView).offset(30)
            make.bottom.equalTo(customView.snp.top).offset(-30)
            make.width.equalTo(175)
            make.height.equalTo(48)
        }
    }
}
