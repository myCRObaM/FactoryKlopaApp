//
//  AppCoordinator.swift
//  KlopaFactory
//
//  Created by Matej Hetzel on 21/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared
import UIKit
import MealsScreen


class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var window: UIWindow?
    var navController: UINavigationController
    var mainCoordinator: RestorauntsCoordinator
    
    init(window: UIWindow) {
        self.window = window
        self.navController = UINavigationController()
        self.mainCoordinator = RestorauntsCoordinator(presenter: navController)
        self.store(coordinator: mainCoordinator)
        navController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        mainCoordinator.start()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
