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

public class RestorauntMealTypesScreenCoordinator: Coordinator {
    let presenter: UINavigationController
    public var childCoordinators: [Coordinator] = []
    let viewController: RestorauntMealTypesScreenController
    let restoraunts: MealCategory
    public weak var coordinatorParent: ParentCoordinatorDelegate?
    
    public init(restoraunts: MealCategory, presenter: UINavigationController) {
        self.restoraunts = restoraunts
        self.presenter = presenter
        let viewModel = RestorauntMealTypesModel(dependencies: RestorauntMealTypesModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), mealCategory: restoraunts))
        self.viewController = RestorauntMealTypesScreenController(viewModel: viewModel)
        viewController.didSelectMealName = self
        viewController.childHasFinished = self
    }
    
    public func start() {
        presenter.pushViewController(viewController, animated: false)
    }
}
extension RestorauntMealTypesScreenCoordinator: didSelectMealName {
    public func openNewCoordinator(meals: [MealsWithRestoraunt]) {
        let sortedByCoord = SortedByMealNameCoordinator(presenter: presenter, meals: meals)
        sortedByCoord.parentCoordinator = self
        self.store(coordinator: sortedByCoord)
        sortedByCoord.start()
    }
}
extension RestorauntMealTypesScreenCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    public func childHasFinished(coordinator: Coordinator) {
        self.free(coordinator: coordinator)
    }

    public func viewControllerHasFinished() {
        coordinatorParent?.childHasFinished(coordinator: self)
    }
}


