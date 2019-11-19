//
//  CollectionViewCell.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Shared


class CollectionViewCell: UICollectionViewCell {
    
    //MARK: ViewElements
    let textLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let customFont = UIFont(name: "Rubik-Black", size: 14)
        view.font = customFont
        view.text = "AAAAAA"
        view.textAlignment = .center
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.shadowColor = .black
        view.textColor = .white
        view.backgroundColor = .clear
        return view
    }()
    
    let image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    
    //MARK: INIT
  override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: SetupView
    func setupView(){
        contentView.addSubview(image)
        contentView.insertSubview(textLabel, aboveSubview: image)
        
    }
    
    func setupConstraints() {
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        image.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    //MARK: Setup Cell
    func setupCell(name: String, url: URL){
        textLabel.text = name
        image.kf.setImage(with: url)
    }
}
