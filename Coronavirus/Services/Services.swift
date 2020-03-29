//
//  Services.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import Foundation

protocol ServicesProviding {
    var covidService: CovidDataProviding { get }
    var analyticsService: AnalyticsProviding { get }
    var contactScannerProviding: ContactScannerProviding { get }
}

struct Services: ServicesProviding {
    var covidService: CovidDataProviding
    var analyticsService: AnalyticsProviding = AnalyticsService()
    var contactScannerProviding: ContactScannerProviding = ContactScannerService()
    
    init(analytics: AnalyticsProviding) {
        covidService = CovidService(analytics: analytics)
    }
}
