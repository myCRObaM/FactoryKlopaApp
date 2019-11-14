//
//  RestorauntsDelegate.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared

protocol SelectedButton: class {
    func openRestorauntScreen()
    func openCategoriesScreen()
}

protocol SelectedRestorauntDelegate: class {
    func openMealCategories(screenData: Restoraunts)
}

protocol SelectedCategoryDelegate: class {
    func openMealCategories(screenData: MealTypes)
}

