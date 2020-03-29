//
//  MyContact.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 28.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

enum ScanResult: Int, Codable {
    case clear, infected, friendsInfected, unknown
    
    var statusColor: UIColor {
        switch self {
        case .clear, .unknown: return UIColor.cvCyan
        case .friendsInfected, .infected: return UIColor.cvYellow
        }
    }
    
    var statusImageName: String {
        switch self {
        case .clear, .unknown: return "iconStatusClear"
        case .infected: return "iconStatusInfected"
        case .friendsInfected: return "iconStatusFriendsInfected"
        }
    }
}

class MyContact {
    var fullName: String
    var phone: String
    var result: ScanResult
    
    init(fullName: String, phone: String, result: ScanResult) {
        self.fullName = fullName
        self.phone = phone
        self.result = result
    }
}

struct ContactCheckResult: Codable {
    var phone: String
    var status: ScanResult
}
