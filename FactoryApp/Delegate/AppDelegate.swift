//
//  AppDelegate.swift
//  FactoryApp
//
//  Created by Matej Hetzel on 14/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
        return true
    }
}

