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
    let restoraunts: MealTypes
    
    init(restoraunts: MealTypes, presenter: UINavigationController) {
        self.restoraunts = restoraunts
        self.presenter = presenter
        let viewModel = RestorauntMealTypesModel(dependencies: RestorauntMealTypesModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), restoraunts: restoraunts))
        self.viewController = RestorauntMealTypesScreenController(viewModel: viewModel)
    }
    
    func start() {
        presenter.pushViewController(viewController, animated: true)
    }
    
    
}
