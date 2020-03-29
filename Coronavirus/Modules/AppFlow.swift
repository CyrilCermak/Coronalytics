//
//  AppFlow.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

class AppFlow {
    
    private lazy var analytics: AnalyticsService = {
      return AnalyticsService()
    }()
    
    private lazy var services: Services = {
       return Services(analytics: analytics)
    }()
    
    lazy var baseNavVC: BaseTopNavVC = {
        return BaseTopNavVC(services: services)
    }()
    
    lazy var navController: BaseNavigationController = {
        return BaseNavigationController(rootViewController: baseNavVC)
    }()
    
    private var currentVC: UIViewController? {
        return navController.viewControllers.last
    }
    
    init() {
        bindBaseVC()
    }
    
    private func bindBaseVC() {
        /// Bind actions here
    }
    
}
