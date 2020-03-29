//
//  StatisticsVC.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

class StatisticsViewModel {
    
    private let covidService: CovidDataProviding
    private var dataProvider: CovidAnalyticsProvider?
    
    init(service: CovidDataProviding) {
        self.covidService = service
    }
    
    func getOverallStats(completion: @escaping(_ overallStats: OverallStats?, _ dailyStats: [DailyStatistic]?, _ error: Error?) -> Void) {
        covidService.getLatestDailyStats { [weak self] (dailyStats, e) in
            guard let self = self, let dailyStats = dailyStats else { return }
            
            self.dataProvider = CovidAnalyticsProvider(data: dailyStats)
            completion(self.covidService.getOverallStats(), self.dataProvider?.getDataGroupedByCountry(),  e)
        }
    }
    
}

class StatisticsVC: BaseVC {
    
    private var statsView = StatisticsView(frame: kBaseTopNavScreenSize)
    lazy var viewModel: StatisticsViewModel = {
        return StatisticsViewModel(service: self.services!.covidService)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        getOverallStats()
        services.analyticsService.log(viewName: "Statistics Screen")
    }
    
    override func loadView() {
        view = statsView
    }
    
    private func bindView() {
        statsView.didChangeRefreshingState = { [weak self] isRefreshing in
            guard isRefreshing else { return }
            self?.getOverallStats()
        }
    }
    
    private func getOverallStats() {
        services.analyticsService.log(event: .pulledData, info: nil)
        viewModel.getOverallStats { [weak self] (stats, dailyStats, e) in
            guard let stats = stats else { return }
            self?.services.analyticsService.log(event: .recievedNewData, info: nil)
            DispatchQueue.main.async {
                self?.statsView.set(overviewStats: stats, countriesStats: dailyStats ?? [])
                self?.statsView.stopRefreshing()
            }
        }
    }
}
