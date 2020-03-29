//
//  StatsTableViewCell.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

class CountryStatsTableViewCell: UITableViewCell, HeightProviding {
    var height: CGFloat = 42
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(size: .normal)
        label.textColor = UIColor.cvYellow
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(size: .normal)
        label.textColor = UIColor.cvYellow
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        initView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func initView() {
        [mainLabel, detailLabel].forEach({ contentView.addSubview($0) })
        mainLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.top.bottom.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-22)
            make.top.bottom.equalToSuperview()
        }
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.cvYellow.cgColor
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-2)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    func set(model: DailyStatistic, type: StatsCountriesType) {
        mainLabel.text = model.state
        switch type {
        case .infected:
            detailLabel.text = "\(model.confirmed)"
            [mainLabel, detailLabel].forEach({ $0.textColor = .cvYellow })
            contentView.layer.borderColor = UIColor.cvYellow.cgColor
        case .recovered:
            detailLabel.text = "\(model.recovered)"
            [mainLabel, detailLabel].forEach({ $0.textColor = .cvCyan })
            contentView.layer.borderColor = UIColor.cvCyan.cgColor
        case .deaths:
            detailLabel.text = "\(model.deaths)"
            [mainLabel, detailLabel].forEach({ $0.textColor = .cvRed })
            contentView.layer.borderColor = UIColor.cvRed.cgColor
        }
    }
}

class StatsTableView: BaseViewWithTableView {
    
    var model: (stats: [DailyStatistic], type: StatsCountriesType)? = ([], .infected) {
        didSet {
            reloadData()
            tableView.setContentOffset(CGPoint(x: 0, y: -20), animated: false)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView.refreshControl = nil
        backgroundColor = .clear
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.clipsToBounds = true
        tableView.register(CountryStatsTableViewCell.self, forCellReuseIdentifier: "CountryStatsTableViewCell")
        tableView.showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CountryStatsTableViewCell") as? CountryStatsTableViewCell, let model = model {
            cell.set(model: model.stats[indexPath.row], type: model.type)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else { return 0 }
        
        return model.stats.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
}

class StatisticsTableViewCell: UITableViewCell, HeightProviding {
    
    var height: CGFloat = {
        if isIphoneX {
            return UIScreen.main.bounds.height - 450
        }
        return UIScreen.main.bounds.height - 390
    }()
    
    var model: (stats: [DailyStatistic], type: StatsCountriesType)? { didSet { statsTableView.model = model } }
    private let statsTableView = StatsTableView()
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.setStatsTableView()
    }
    
    private func setStatsTableView() {
        contentView.addSubview(statsTableView)
        statsTableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview()
        }
    }
}
