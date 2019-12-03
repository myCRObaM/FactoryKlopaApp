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
import WishList

class SortedByMealNameCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let viewController: SortedByNameVC
    let meals: [MealsWithRestoraunt]
    public weak var parentCoordinator: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController, meals: [MealsWithRestoraunt]) {
        self.presenter = presenter
        self.meals = meals
        let viewModel = SortedByMealNameModel(dependencies: SortedByMealNameModel.Dependencies(meals: meals, scheduler: ConcurrentDispatchQueueScheduler(qos: .background), realmManager: RealmManager()))
        self.viewController = SortedByNameVC(viewModel: viewModel)
        viewController.childHasFinished = self
        viewController.basketButtonPress = self
    }
    
    func start() {
        presenter.pushViewController(viewController, animated: false)
    }
    
    
}

extension SortedByMealNameCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator) {
        self.free(coordinator: coordinator)
    }
    
    func viewControllerHasFinished() {
        parentCoordinator?.childHasFinished(coordinator: self)
    }
    
    
}
extension SortedByMealNameCoordinator: CartButtonPressed{
    public func openCart() {
        let wishListCoordinator = WishListCoordinator(presenter: presenter)
        wishListCoordinator.parentCoordinator = self
        self.store(coordinator: wishListCoordinator)
        wishListCoordinator.start()
    }
    
    
}
