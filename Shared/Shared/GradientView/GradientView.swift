//
//  GradientView.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 07/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Hue

public class GradientView: UIView {
    
    var gradient: CAGradientLayer = [UIColor(hex: "#DCDCDC"), UIColor(hex: "#ffffff")].gradient()
    
    
    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient.frame = self.bounds
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI(){
        self.gradient.frame = self.bounds
        self.layer.insertSublayer(self.gradient, at: 0)
    }
}
