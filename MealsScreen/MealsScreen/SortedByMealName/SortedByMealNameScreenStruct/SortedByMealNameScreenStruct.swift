//
//  SortedByMealNameScreenStruct.swift
//  MealsScreen
//
//  Created by Matej Hetzel on 28/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
struct Section {
    var mealName: String
    var data: [Rows]
}

struct Rows {
    var restorauntName: String
    var mob: String?
    var tel: String?
    var price: String?
    var ingredients: String
    var priceJumbo: String?
    var priceNormal: String?
}
