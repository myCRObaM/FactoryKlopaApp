//
//  RestorauntsDelegate.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation

public protocol SelectedButton: class {
    func openRestorauntScreen()
    func openCategoriesScreen()
}

public protocol SelectedRestorauntDelegate: class {
    func openMealCategories(screenData: Restoraunts)
}

public protocol SelectedCategoryDelegate: class {
    func openMealType(screenData: MealCategory)
}

