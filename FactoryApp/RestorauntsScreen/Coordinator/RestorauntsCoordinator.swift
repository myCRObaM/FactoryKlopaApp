//
//  RestorauntsCoordinator.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared
import UIKit
import RxSwift
import MealsScreen

public class RestorauntsCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let viewController: RestorauntsViewController
    
    
    public init(presenter: UINavigationController) {
        self.presenter = presenter
        let viewModel = RestorauntsViewModel(dependencies: RestorauntsViewModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), repo: DataRepo()))
        self.viewController = RestorauntsViewController(viewModel: viewModel)
        viewController.didSelectRestoraunt = self
        viewController.didSelectCategory = self
    }
    
    public func start() {
        presenter.setNavigationBarHidden(true, animated: true)
        presenter.pushViewController(viewController, animated: true)
    }
    
    
}
extension RestorauntsCoordinator: SelectedRestorauntDelegate, SelectedCategoryDelegate {
    public func openMealType(screenData: MealCategory) {
           let categoryScreen = RestorauntMealTypesScreenCoordinator(restoraunts: screenData, presenter: presenter)
             self.store(coordinator: categoryScreen)
             categoryScreen.start()
    }
    public func openMealCategories(screenData: Restoraunts) {
        let mealList = MealsScreenCoordinator(presenter: presenter, screenData: screenData)
        self.store(coordinator: mealList)
        mealList.start()
    }
}
