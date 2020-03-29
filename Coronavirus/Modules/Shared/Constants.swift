//
//  Constants.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation
import UIKit

let isSmallIPhone: Bool = iPhoneSize.sizeForDevice() == .small
let isMidSizeIphone: Bool = iPhoneSize.sizeForDevice() == .middle
let isBigSizeIphone: Bool = iPhoneSize.sizeForDevice() == .big
let isIphoneX: Bool = UIScreen.main.bounds.height >= 812
let screenSize: CGRect = UIScreen.main.bounds
let kBaseTopNavScreenSize = CGRect(x: 0, y: isIphoneX ? 34 : 0, width: screenSize.width, height: isIphoneX ? screenSize.height-34 : screenSize.height)

enum iPhoneSize: Int {
    case small = 568
    case middle = 667
    case big = 736
    case x = 812
    case xMax = 896
    case unsupported = 0
    
    static func sizeForDevice() -> iPhoneSize {
        switch Int(UIScreen.main.bounds.height) {
        case iPhoneSize.small.rawValue : return iPhoneSize.small
        case iPhoneSize.middle.rawValue: return iPhoneSize.middle
        case iPhoneSize.big.rawValue: return iPhoneSize.big
        case iPhoneSize.x.rawValue: return iPhoneSize.x
        case iPhoneSize.xMax.rawValue: return iPhoneSize.xMax
        default: return iPhoneSize.unsupported
        }
    }
}
