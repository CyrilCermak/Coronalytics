//
//  StatisticsView.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

class StatisticsView: BaseViewWithTableView {
    
    var stateChanged: ((StatsCountriesType) -> Void)?
    
    private var overviewCell = OverviewChartCell()
    private let buttonsCell = StatisticsButtonCell()
    private let countriesStatsCell = StatisticsTableViewCell()
    
    private var overallStats: OverallStats?
    private var countriesStats: [DailyStatistic]?
    private var countriesStateChanged: ((StatsCountriesType) -> Void)?
    
    private lazy var statsCells: [UITableViewCell] = {
       return [overviewCell, buttonsCell]
    }()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        cells = statsCells
        tableView.scrollsToTop = false
        buttonsCell.countriesStateChanged = { countriesState in
            self.countriesStatsCell.model = (stats: self.countriesStats ?? [], type: countriesState)
        }
        
        if isSmallIPhone {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
                self.tableView.setContentOffset(CGPoint(x: 0, y: 50), animated: false)
            }
        }
    }
    
    func set(overviewStats: OverallStats, countriesStats: [DailyStatistic]) {
        self.overallStats = overviewStats
        self.countriesStats = countriesStats
        overviewCell = OverviewChartCell()
        
        countriesStatsCell.model = (stats: countriesStats, type: .infected)
        
        cells = [overviewCell, buttonsCell, countriesStatsCell]
        reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = cells[indexPath.row] as? OverviewChartCell {
            if let stats = overallStats {
                cell.set(recoverd: stats.recovered, infected: stats.confirmed, deaths: stats.deaths)
            }
            return cell
        }
        
        return cells[indexPath.row]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 30 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}
