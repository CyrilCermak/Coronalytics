//
//  StatisticsButtonCell.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

class StatisticsButtonCell: UITableViewCell, HeightProviding {
    var height: CGFloat = 44
    let buttonView = StatsTypeButtonsView()
    var countriesStateChanged: ((StatsCountriesType) -> Void)? {
        didSet {
            buttonView.countriesStateChanged = countriesStateChanged
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.initView()
    }
    
    
    private func initView() {
        contentView.addSubview(buttonView)
        buttonView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
