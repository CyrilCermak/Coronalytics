//
//  SwitchingTabBar.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class SwitchingTabBar: UIView {
    static let height: CGFloat = 50
    
    var buttons: [UIButton] = []
    var currentlyActive: UIButton?
    let indicatorView = UIView()
    let stackView = UIStackView()
    var state: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setStackView()
    }
    
    func set(titles: [String]) {
        self.buttons = [UIButton]()
        for title in titles {
            let btn = UIButton()
            btn.setTitle(title, for: .normal)
            self.buttons.append(btn)
        }
        
        initView()
        updateView(activatedButton: buttons.first!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        for button in buttons {
            self.stackView.addArrangedSubview(button)
            button.snp.makeConstraints({ $0.height.equalTo(50); $0.width.equalTo(UIScreen.main.bounds.width/3)})
            button.addTarget(self, action: #selector(self.didTap(button:)), for: .touchUpInside)
        }
        
        setIndicator()
    }
    
    private func setStackView() {
        self.stackView.alignment = .center
        self.stackView.distribution = .fillEqually
        self.stackView.axis = .horizontal
        
        self.addSubview(stackView)
        self.stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-2)
            make.bottom.equalToSuperview().offset(2)
            make.left.equalToSuperview().offset(-1)
            make.right.equalToSuperview().offset(1)
        }
    }
    
    @objc func didTap(button: UIButton) {
        self.updateView(activatedButton: button)
    }
    
    private func setIndicator() {
        self.addSubview(indicatorView)
        let width = UIScreen.main.bounds.width/CGFloat(buttons.count) + 1
        self.indicatorView.snp.makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.equalTo(2)
            make.left.equalToSuperview().offset(0)
            make.bottom.equalTo(self.stackView).offset(-2)
        }
    }
    
    private func updateView(activatedButton: UIButton) {
        guard activatedButton != currentlyActive else { return }
        currentlyActive = activatedButton
        self.updateButtons(activatedButton: activatedButton)
        let index = buttons.firstIndex(of: activatedButton) ?? 0
        state?(index)
        self.animateIndicator(for: index)
    }
    
    private func updateButtons(activatedButton: UIButton) {
        activatedButton.isSelected = true
        buttons.forEach({ if $0 != activatedButton { $0.isSelected = false } })
    }
    
    private func animateIndicator(for index: Int) {
        let buttonWidth = UIScreen.main.bounds.width/CGFloat(buttons.count) - 1
        UIView.animate(withDuration: 0.5, animations: {
            self.indicatorView.snp.updateConstraints({ (make) in
                make.left.equalToSuperview().offset(buttonWidth * CGFloat(index))
            })
            self.layoutIfNeeded()
        })
    }
}
