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


public class RestorauntsSingleCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let screenData: Restoraunts
    let viewController: RestorauntsScreenViewController
    
    
    public init(presenter: UINavigationController, screenData: Restoraunts) {
        self.presenter = presenter
        self.screenData = screenData
        let viewModel = RestorauntsSingleModel(dependencies: RestorauntsSingleModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), meals: screenData))
        self.viewController = RestorauntsScreenViewController(viewModel: viewModel)
    }
    
    public func start() {
        presenter.setNavigationBarHidden(true, animated: true)
        presenter.pushViewController(viewController, animated: false)
    }
    
    
}
