//
//  MealNameDelegate.swift
//  MealsScreen
//
//  Created by Matej Hetzel on 19/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared

protocol didSelectMealName: class {
    func openNewCoordinator(meals: [MealsWithRestoraunt])
}
