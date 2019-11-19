//
//  SortedByMealNameCoordinator.swift
//  MealsScreen
//
//  Created by Matej Hetzel on 19/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared
import RxSwift
import UIKit

class SortedByMealNameCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let viewController: SortedByNameVC
    let meals: [MealsWithRestoraunt]
    
    init(presenter: UINavigationController, meals: [MealsWithRestoraunt]) {
        self.presenter = presenter
        self.meals = meals
        let viewModel = SortedByMealNameModel(dependencies: SortedByMealNameModel.Dependencies(meals: meals, scheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
        self.viewController = SortedByNameVC(viewModel: viewModel)
    }
    
    func start() {
        presenter.pushViewController(viewController, animated: false)
    }
    
    
}
