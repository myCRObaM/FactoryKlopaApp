//
//  MealsScreenCoordinator.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 31/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared
import RxSwift
import UIKit
import WishList


public class RestorauntsSingleCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let screenData: Restoraunts
    let viewController: RestorauntsScreenViewController
    
    
    public init(presenter: UINavigationController, screenData: Restoraunts) {
        self.presenter = presenter
        self.screenData = screenData
        let viewModel = RestorauntsSingleModel(dependencies: RestorauntsSingleModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), meals: screenData, realmManager: RealmManager()))
        self.viewController = RestorauntsScreenViewController(viewModel: viewModel)
        viewController.basketButtonPress = self
    }
    
    public func start() {
        presenter.setNavigationBarHidden(true, animated: true)
        presenter.pushViewController(viewController, animated: false)
    }
    
    
}

extension RestorauntsSingleCoordinator: CartButtonPressed{
    public func openCart() {
        let wishListCoordinator = WishListCoordinator(presenter: presenter)
        self.store(coordinator: wishListCoordinator)
        wishListCoordinator.start()
    }
    
    
}
