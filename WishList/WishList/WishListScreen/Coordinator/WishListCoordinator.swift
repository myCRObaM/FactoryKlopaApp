//
//  WishListCoordinator.swift
//  WishList
//
//  Created by Matej Hetzel on 21/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared
import RxSwift
import UIKit


public class WishListCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let viewController: WishListViewController
    public weak var parentCoordinator: ParentCoordinatorDelegate?
    
    public init(presenter: UINavigationController){
        self.presenter = presenter
        let viewModel = WishListViewModel(dependencies: WishListViewModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), realmRepo: RealmManager()))
        self.viewController = WishListViewController(viewModel: viewModel)
        viewController.childHasFinished = self
    }
    
    public func start() {
        presenter.pushViewController(viewController, animated: false)
    }
    
    
}
extension WishListCoordinator: CoordinatorDelegate {
    public func viewControllerHasFinished() {
        parentCoordinator?.childHasFinished(coordinator: self)
    }
    
    
}
