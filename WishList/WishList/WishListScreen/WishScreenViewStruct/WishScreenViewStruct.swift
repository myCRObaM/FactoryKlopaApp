//
//  WishScreenViewStruct.swift
//  WishList
//
//  Created by Matej Hetzel on 28/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation

struct Section {
    var restorauntName: String
    var mob: String
    var tel: String
    var data: [Row]
}

struct Row {
    var mealName: String
    var ingredients: String?
    var price: String?
}
