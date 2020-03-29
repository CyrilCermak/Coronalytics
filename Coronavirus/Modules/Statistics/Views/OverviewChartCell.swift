//
//  OverviewChartCell.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 26.03.20.
//  Copyright © 2018 Cyril. All rights reserved.
//

import Foundation
import UIKit
import PieCharts

protocol HeightProviding {
    var height: CGFloat { get }
}

class OverviewChartCell: UITableViewCell, HeightProviding {
    
    var height: CGFloat = 300
    private let hundredPercentIdentifier = 99.99999912345
    private let pieChart = PieChart(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-32, height: 250))
    private var backgroundImageView: UIImageView = {
       return UIImageView(image: UIImage(named: "graph_background")!)
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.regular(size: .extraExtraLarge)
        titleLabel.text = "COVID-19"
        titleLabel.textColor = UIColor.cvGrey
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        setContentView()
        setPieChart()
        setPointsLabel()
    }
    
    private func setPointsLabel() {
        contentView.addSubview(self.titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(120)
        }
    }
    
    private func setContentView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(pieChart)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentView.bringSubviewToFront(pieChart)
    }
    
    private func setPieChart() {
        pieChart.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(25)
        }
        pieChart.isHidden = true
        pieChart.innerRadius = isSmallIPhone ? 75 : 85
        pieChart.outerRadius = isSmallIPhone ? 90 : 100
        pieChart.animDuration = 0.5
        pieChart.selectedOffset = 30
    }
    
    private func setPieChartSlicesFor(recoverd: Int, infected: Int, deaths: Int) {
        pieChart.layers = [
            percentageLayer()
        ]
        if recoverd == 0 && infected == 0 && deaths == 0 {
            self.pieChart.models = [
                PieSliceModel(value: hundredPercentIdentifier, color: UIColor.cvGrey),
            ]
            return
        }
        self.pieChart.models = [
            PieSliceModel(value: Double(recoverd), color: UIColor.cvCyan, obj: "\(recoverd)\nRecovered"),
            PieSliceModel(value: Double(infected), color: UIColor.cvYellow, obj: "\(infected)\nInfected"),
            PieSliceModel(value: Double(deaths), color: UIColor.cvRed, obj: "\(deaths)\nDeaths"),
        ]
    }

    private func percentageLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = isSmallIPhone ? 120 : 150
        textLayerSettings.hideOnOverflow = false
        textLayerSettings.label.labelGenerator = {slice in
            let label = UILabel()
            label.font = UIFont.regular(size: isSmallIPhone ? .small : .normal)
            label.textColor = slice.data.model.color
            label.numberOfLines = 2
            label.textAlignment = .center
            return label
        }
        
        textLayerSettings.label.textGenerator = { slice in
            if String(describing: slice.data.percentage) == "nan" { return "0" }
            if slice.data.model.value == self.hundredPercentIdentifier { return "0" }
            return slice.data.model.obj as? String ?? ""
        }
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    func set(recoverd: Int, infected: Int, deaths: Int) {
        pieChart.isHidden = false
        setPieChartSlicesFor(recoverd: recoverd, infected: infected, deaths: deaths)
    }
}
