//
//  RealmRestorauntsDataModel.swift
//  Shared
//
//  Created by Matej Hetzel on 21/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRestorauntsDataModel: Object {
        @objc dynamic var name: String = ""
        @objc dynamic var restoraunt: String = ""
        @objc dynamic var price: String? = ""
        @objc dynamic var priceJumbo: String? = ""
        @objc dynamic var priceNormal: String? = ""
        @objc dynamic var mob: String? = ""
        @objc dynamic var tel: String? = ""
        @objc dynamic var ingredients: String? = ""
        
        func createRestoraunt(meal: MealsWithRestoraunt){
            self.name = meal.name
            self.restoraunt = meal.restorauntName
            self.price = meal.price
            self.priceJumbo = meal.priceJumbo
            self.priceNormal = meal.priceNormal
            self.mob = meal.mobLabel
            self.tel = meal.telLabel
            var ingredintsLocal = "("
            for ingredient in meal.ingredients ?? []{
                if ingredintsLocal == "("{
                    ingredintsLocal = ingredintsLocal + ingredient.name!
                }
                else {
                    ingredintsLocal = ingredintsLocal + ", " + ingredient.name!
                }
            }
            self.ingredients = ingredintsLocal + ")"
        }
        
        override class func primaryKey() -> String?{
            return "name"
        }
    }
