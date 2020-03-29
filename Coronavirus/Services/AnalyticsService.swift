//
//  AnalyticsService.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 26.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import Foundation
import Firebase

enum AnalyticsEvent: String {
    case pulledData = "New Data Pulled"
    case recievedNewData = "New Data Recieved"
}

enum AnalyticsError: String {
    case noDataRecieved = "No Data Recieved"
}

protocol AnalyticsProviding {
    func log(event: AnalyticsEvent, info: [String : String]?)
    func log(error: AnalyticsError, info: [String : String]?)
    func log(viewName: String)
}

class AnalyticsService: AnalyticsProviding {
    
    func log(event: AnalyticsEvent, info: [String : String]?) {
        Analytics.logEvent(event.rawValue, parameters: info)
    }
    
    func log(error: AnalyticsError, info: [String : String]?) {
        print("Error: \(error.rawValue) -> \(info ?? [:])")
        Analytics.logEvent(error.rawValue, parameters: info)
    }
    
    func log(viewName: String) {
        Analytics.setScreenName(viewName, screenClass: viewName)
    }
    
}
