//
//  MealCategoriesStruct.swift
//  Shared
//
//  Created by Matej Hetzel on 03/12/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation

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
