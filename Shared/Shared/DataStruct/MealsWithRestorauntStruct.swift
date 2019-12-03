//
//  MealsWithRestorauntStruct.swift
//  Shared
//
//  Created by Matej Hetzel on 03/12/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation

public struct MealsWithRestoraunt {
    public var name: String
    public var priceNormal: String?
    public var priceJumbo: String?
    public var price: String?
    public var ingredients: [Ingredients]?
    public var restorauntName: String
    public var mobLabel: String?
    public var telLabel: String?
    public var isPizza: Bool = false
    
    public init(name: String, priceNormal: String?, priceJumbo: String?, price: String?, ingredients: [Ingredients]? , restorauntName: String, mobLabel: String?, telLabel: String?, isPizza: Bool = false) {
        self.name = name
        self.priceNormal = priceNormal
        self.priceJumbo = priceJumbo
        self.price = price
        self.ingredients = ingredients
        self.restorauntName = restorauntName
        self.mobLabel = mobLabel
        self.telLabel = telLabel
        self.isPizza = isPizza
    }
}
