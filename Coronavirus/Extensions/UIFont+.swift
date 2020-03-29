//
//  UIFont+.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

extension UIFont {
    enum FontSize: Int {
        case small = 12
        case normal = 16
        case large = 20
        case extraLarge = 24
        case extraExtraLarge = 30
    }
    
    static func regular(size: FontSize) -> UIFont {
        return UIFont(name: "Lato-Regular", size: CGFloat(size.rawValue))!
    }
    
    static func semibold(size: FontSize) -> UIFont {
        return UIFont(name: "Lato-Semibold", size: CGFloat(size.rawValue))!
    }
    
    static func bold(size: FontSize) -> UIFont {
        return UIFont(name: "Lato-Bold", size: CGFloat(size.rawValue))!
    }
}
