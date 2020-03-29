//
//  BaseTopNavVC.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//


import UIKit

protocol BaseNavDelegate: class {
    func showTermsAndCond()
}

class BaseTopNavVC: BaseVC {
    
    private let topNavView = BaseTopNavView(frame: UIScreen.main.bounds)
    
    private lazy var spreadMapVC: BaseVC = {
        return BaseVC(services: services)
    }()
    
    private lazy var statisticsVC: BaseVC = {
        let vc = StatisticsVC(services: services)
        return vc
    }()
    
    lazy var myContactsVC: MyContactsVC = {
        let vc = MyContactsVC(services: services)
        return vc
    }()
    
    private lazy var viewControllers: [BaseVC] = {
        return [myContactsVC, statisticsVC, spreadMapVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setVCs()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func loadView() {
        self.view = topNavView
    }
    
    private func setVCs() {
        topNavView.mainActionView.contentSize = CGSize(width: CGFloat(viewControllers.count) * screenSize.width, height: screenSize.height-64)
        
        topNavView.titles.append(contentsOf: ["My Contacts", "Statistics", "Map"].map({ $0.uppercased() }))
        for (index, vc) in viewControllers.enumerated() {
            vc.parentingVC = self
            vc.view.frame.origin = CGPoint(x: screenSize.width * CGFloat(index), y: 64)
            self.topNavView.mainActionView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
}
