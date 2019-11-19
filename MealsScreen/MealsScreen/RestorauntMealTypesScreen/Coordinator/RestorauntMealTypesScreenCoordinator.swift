//
//  RestorauntMealTypesScreenCoordinator.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Shared
import RxSwift

class RestorauntMealTypesScreenCoordinator: Coordinator {
    let presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    let viewController: RestorauntMealTypesScreenController
    let restoraunts: MealCategory
    
    init(restoraunts: MealCategory, presenter: UINavigationController) {
        self.restoraunts = restoraunts
        self.presenter = presenter
        let viewModel = RestorauntMealTypesModel(dependencies: RestorauntMealTypesModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), mealCategory: restoraunts))
        self.viewController = RestorauntMealTypesScreenController(viewModel: viewModel)
        viewController.didSelectMealName = self
    }
    
    func start() {
        presenter.pushViewController(viewController, animated: false)
    }
    
    
}
extension RestorauntMealTypesScreenCoordinator: didSelectMealName{
    
    func openNewCoordinator(meals: [MealsWithRestoraunt]) {
        let sortedByCoord = SortedByMealNameCoordinator(presenter: presenter, meals: meals)
        self.store(coordinator: sortedByCoord)
        sortedByCoord.start()
    }
    
}
