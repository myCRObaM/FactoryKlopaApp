//
//  MainScreenCoordinator.swift
//  KlopaFactory
//
//  Created by Matej Hetzel on 21/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared
import UIKit
import RxSwift
import MealsScreen


class MainScreenCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let viewController: MainChooserScreenController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        let viewModel = MainScreenViewModel(dependencies: MainScreenViewModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
        self.viewController = MainChooserScreenController(viewModel: viewModel)
        viewController.newScreenDelegate = self
    }
    
    func start() {
        presenter.setViewControllers([viewController], animated: false)
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    
}

extension MainScreenCoordinator: NewOrderScreenDelegate {
    func openNewOrder() {
        let restorauntsCoordinator = RestorauntsCoordinator(presenter: presenter)
        self.store(coordinator: restorauntsCoordinator)
        restorauntsCoordinator.start()
    }
}
