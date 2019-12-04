//
//  AboutUsScreen.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 12/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AboutUsScreen: UIView {
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
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
        self.addSubview(mapView)
        self.backgroundColor = .white
        setupConstraints()
    }
    
    func setupConstraints(){
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(5)
            
        }
    }
}
