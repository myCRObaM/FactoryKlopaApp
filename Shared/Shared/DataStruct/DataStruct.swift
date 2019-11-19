//
//  DataStruct.swift
//  Shared
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation

public struct Restoraunts {
    public var name: String
    public var tel: String?
    public var mob: String?
    public var workingHours: String?
    public var meals: [MealTypes]
    
    public init(name: String, tel: String?, mob: String?, workingHours: String?, meals: [MealTypes]){
        self.name = name
        self.tel = tel
        self.mob = mob
        self.workingHours = workingHours
        self.meals = meals
    }
}
public struct Meals {
    public var name: String
    public var priceNormal: String?
    public var priceJumbo: String?
    public var price: String?
    public var ingredients: [Ingredients]?
    
    public init(name: String, priceNormal: String?, priceJumbo: String?, price: String?, ingredients: [Ingredients]?) {
        self.name = name
        self.priceNormal = priceNormal
        self.priceJumbo = priceJumbo
        self.price = price
        self.ingredients = ingredients
    }
}

public struct Ingredients {
    public var name: String?
    public init(name: String?) {
        self.name = name
    }
}

public struct MealTypes {
    public var type: MealTypeEnum
    public var meals: [Meals]
    public var isCollapsed: Bool
    
    public init(type: MealTypeEnum, meals: [Meals], isCollapsed: Bool? = true){
        self.type = type
        self.meals = meals
        self.isCollapsed = isCollapsed ?? true
    }
}

public struct MealCategory {
    public var type: MealTypeEnum
    public var meals: [MealsWithRestoraunt]

    
    public init(type: MealTypeEnum, meals: [MealsWithRestoraunt]){
        self.type = type
        self.meals = meals

    }
}

public struct MealsWithRestoraunt {
    public var name: String
    public var priceNormal: String?
    public var priceJumbo: String?
    public var price: String?
    public var ingredients: [Ingredients]?
    public var restorauntName: String
    public var mobLabel: String?
    public var telLabel: String?
    
    public init(name: String, priceNormal: String?, priceJumbo: String?, price: String?, ingredients: [Ingredients]? , restorauntName: String, mobLabel: String?, telLabel: String?) {
        self.name = name
        self.priceNormal = priceNormal
        self.priceJumbo = priceJumbo
        self.price = price
        self.ingredients = ingredients
        self.restorauntName = restorauntName
        self.mobLabel = mobLabel
        self.telLabel = telLabel
    }
}
