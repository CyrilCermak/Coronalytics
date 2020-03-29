//
//  BaseVC.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    
    weak var parentingVC: BaseVC?
    var services: Services!
    
    convenience init(services: Services) {
        self.init()
        self.services = services
    }
    
    override func viewDidLoad() {
        print("BaseVC: \(self.classForCoder) did load")
        super.viewDidLoad()
    }
    
    deinit {
        print("BaseVC: \(self.classForCoder) deinited")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
}
