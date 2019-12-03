//
//  IngredientsOperator.swift
//  Shared
//
//  Created by Matej Hetzel on 28/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
public class IngredientsOperator {
    public func returnIngredients(data: MealsWithRestoraunt) -> String{
        var ingredients: String = ""
        if data.ingredients?.count ?? 0 > 0 {
            ingredients = ""
            for ingredient in data.ingredients! {
                if ingredients != "" {
                    ingredients = ingredients + ", " + ingredient.name!
                }
                else {
                    ingredients = ingredient.name!
                }
            }
        }
        return ingredients
    }
    
    public init(){
        
    }
}
