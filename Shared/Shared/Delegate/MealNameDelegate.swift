//
//  MealNameDelegate.swift
//  MealsScreen
//
//  Created by Matej Hetzel on 19/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation

public protocol didSelectMealName: class {
    func openNewCoordinator(meals: [MealsWithRestoraunt])
}
