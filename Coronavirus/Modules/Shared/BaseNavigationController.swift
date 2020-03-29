//
//  MotivationNavigationController.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation
import UIKit

class BasePopNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initNavcontroller()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.initNavcontroller()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initNavcontroller() {
        self.applyBaseStyling()
    }
}

class BaseNavigationController: UINavigationController {
    
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.initNavcontroller()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    func initNavcontroller() {
        self.applyBaseStyling()
    }
    
    func hideNavbar() {
        self.isNavigationBarHidden = true
    }
    
    func showNabar() {
        self.isNavigationBarHidden = false
    }
    
    func sendNavBarToBack() {
        self.navigationBar.barTintColor = .white
        self.navigationBar.layer.zPosition = -1
    }
    
    func sendNavBarToFront() {
        self.navigationBar.layer.zPosition = 1000
    }
    
    
    
    // MARK: - Overrides
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        
        super.pushViewController(viewController, animated: animated)
    }

    // MARK: - Private Properties
    
    fileprivate var duringPushAnimation = false
    
    // MARK: - Unsupported Initializers
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let ccNavigationController = navigationController as? BaseNavigationController else { return }
        
        ccNavigationController.duringPushAnimation = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}

extension UINavigationController {
    func applyBaseStyling() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .white
        self.navigationBar.tintColor = .white
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
    }
}

