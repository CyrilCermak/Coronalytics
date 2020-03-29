//
//  AppDelegate.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 26.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var flow: AppFlow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        initWindow()
        return true
    }

    private func initWindow() {
        self.flow = AppFlow()
        self.window = UIWindow()
        self.window?.rootViewController = flow.navController
        self.window?.makeKeyAndVisible()
    }
}
