//
//  CovidService.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 26.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import Foundation

struct DailyStatistic: Codable {
    let city: String
    let state: String
    let lastUpdate: String
    let confirmed: Int
    let deaths: Int
    let recovered: Int
}

struct OverallStats {
    let confirmed: Int
    let recovered: Int
    let deaths: Int
}

protocol CovidDataProviding {
    func getLatestDailyStats(completion: @escaping(_ stats: [DailyStatistic]?, _ error: Error?) -> Void)
    func getOverallStats() -> OverallStats
}

class CovidService: CovidDataProviding {
    
    private let network = NetworkLayer()
    private let latestDaily = "https://eosmate.io:9090/api/v1/daily_analytics"
    private var dailyStats: [DailyStatistic] = []
    private var analytics: AnalyticsProviding
    
    init(analytics: AnalyticsProviding) {
        self.analytics = analytics
    }
    
    func getLatestDailyStats(completion: @escaping(_ stats: [DailyStatistic]?, _ error: Error?) -> Void) {
        network.get(url: URL(string: latestDaily)!, body: nil) { [weak self] (data, error) in
            guard let data = data else {
                self?.analytics.log(error: .noDataRecieved, info: ["Daily Stats": error?.localizedDescription ?? ""])
                return completion(nil, error)
            }
            
            do {
                self?.dailyStats = try JSONDecoder().decode([DailyStatistic].self, from: data)
            } catch {
                print("Could not decode")
            }
            
            return completion(self?.dailyStats, nil)
        }
    }
    
    func getOverallStats() -> OverallStats {
        var confirmed: Int = 0
        var recovered: Int = 0
        var deaths: Int = 0
        dailyStats.forEach { (countryStatistic) in
            confirmed += countryStatistic.confirmed
            recovered += countryStatistic.recovered
            deaths += countryStatistic.deaths
        }
        return OverallStats(confirmed: confirmed, recovered: recovered, deaths: deaths)
    }
        
}

class CovidAnalyticsProvider {
    var stats: [DailyStatistic]
    
    init(data: [DailyStatistic]) {
        self.stats = data
    }
    
    func getDataGroupedByCountry() -> [DailyStatistic] {
        var groupedStats = [DailyStatistic]()
        var tmpDict = [String:[DailyStatistic]]()
        stats.forEach { (stat) in
            if tmpDict[stat.city] == nil {
                tmpDict[stat.city] = [stat]
            } else {
                tmpDict[stat.city]?.append(stat)
            }
        }
        
        tmpDict.forEach { (key,value) in
            var analytics = (confirmed: 0, recovered: 0, deaths: 0)
            value.forEach({
                analytics.confirmed += $0.confirmed
                analytics.recovered += $0.recovered
                analytics.deaths += $0.deaths
            })
            
            groupedStats.append(DailyStatistic(city: "", state: key, lastUpdate: "", confirmed: analytics.confirmed, deaths: analytics.deaths, recovered: analytics.recovered))
        }
        
        return groupedStats.sorted(by: { $0.confirmed > $1.confirmed})
    }
}
