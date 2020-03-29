//
//  SwitchingBar.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

enum StatsCountriesType {
    case infected, deaths, recovered
}

class StatsTypeButtonsView: UIView {
    static let height: CGFloat = 50
    var countriesStateChanged: ((StatsCountriesType) -> Void)?
    
    private lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setTitle("INFECTED", for: .normal)
        leftButton.setTitleColor(UIColor.cvYellow, for: .normal)
        return leftButton
    }()
    
    private lazy var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setTitle("RECOVERED", for: .normal)
        rightButton.setTitleColor(UIColor.cvCyan, for: .normal)
        return rightButton
    }()
    
    private lazy var centerButon: UIButton = {
        let centerButon = UIButton()
        centerButon.setTitle("DEATHS", for: .normal)
        centerButon.setTitleColor(UIColor.cvRed, for: .normal)
        return centerButon
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setButtons()
        self.setStackView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setButtons() {
        [leftButton, centerButon, rightButton].forEach({ (button) in
            self.stackView.addArrangedSubview(button)
            button.snp.makeConstraints({ $0.height.equalToSuperview() })
            
            button.titleLabel?.font = UIFont.regular(size: .small)
            button.backgroundColor = UIColor.clear
            button.setTitleColor(UIColor.cvGrey, for: .selected)
            button.addTarget(self, action: #selector(didTap(button:)), for: .touchUpInside)
            button.layer.borderColor = UIColor.cvBorder.cgColor
            button.layer.borderWidth = 1
        })
    }
    
    private func setStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func didTap(button: UIButton) {
        if button == leftButton {
            countriesStateChanged?(.infected)
        }
        if button == rightButton {
            countriesStateChanged?(.recovered)
        }
        if button == centerButon {
            countriesStateChanged?(.deaths)
        }
    }
}
