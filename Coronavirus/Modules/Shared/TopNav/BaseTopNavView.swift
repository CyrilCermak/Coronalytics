//
//  BaseTopNavView.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum TopNavViewButtonType {
    case info, statistics, map
}

class BaseTopNavView: UIView {
    
    let mainActionView = UIScrollView()
    var titles = [String]() { didSet { self.setViewState() } }
    
    private let backgroundImage = UIImageView()
    private let topNavView = UIView()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let pagingControl = UIPageControl()
    private let navTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        addViews()
        
        setBackgroundImage()
        setTopNavView()
        setButtons()
        setMainActionView()
        setPageControl()
        setNavTitle()
        setInitialPosition()
        setViewState()
        
        sendSubviewToBack(backgroundImage)
    }
    
    private func addViews() {
        [topNavView, backgroundImage, leftButton, rightButton, pagingControl, navTitle, mainActionView].forEach({ self.addSubview($0) })
    }
    
    private func setBackgroundImage() {
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setTopNavView() {
        topNavView.backgroundColor = .clear
        sendSubviewToBack(mainActionView)
        topNavView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(isIphoneX ? 83 : 59)
        }
    }
    
    private func setButtons() {
        leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(isIphoneX ? 45 : 25)
            make.width.height.equalTo(25)
        }
        
        rightButton.setImage(UIImage(named: "nav_icon_map")!, for: .normal)
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.leftButton)
            make.width.height.equalTo(25)
        }
    }
    
    @objc func didTapLeftButton() {
        moveScrollView(toFront: false)
        setViewState()
    }
    
    @objc func didTapRightButton() {
        moveScrollView(toFront: true)
        setViewState()
    }
    
    private func setMainActionView() {
        mainActionView.isScrollEnabled = true
        mainActionView.showsHorizontalScrollIndicator = false
        mainActionView.showsVerticalScrollIndicator = false
        mainActionView.clipsToBounds = false
        mainActionView.bounces = false
        mainActionView.isPagingEnabled = true
        mainActionView.delegate = self
        mainActionView.contentInsetAdjustmentBehavior = .never
        mainActionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(isIphoneX || isSmallIPhone ? 15 : -15)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setNavTitle() {
        navTitle.textColor = UIColor.baseColor
        navTitle.textAlignment = .center
        navTitle.font = UIFont.regular(size: .normal)
        navTitle.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(20)
            if isIphoneX {
                make.centerY.equalTo(self.topNavView).offset(10)
                make.centerX.equalTo(self.topNavView)
            } else {
                make.center.equalTo(self.topNavView)
            }
        }
    }
    
    fileprivate func setPageControl() {
        pagingControl.currentPage = 0
        pagingControl.numberOfPages = 3
        pagingControl.pageIndicatorTintColor = UIColor.baseColor.withAlphaComponent(0.4)
        pagingControl.currentPageIndicatorTintColor = UIColor.baseColor
        
        pagingControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.topNavView)
            make.height.equalTo(10)
            make.bottom.equalTo(self.topNavView.snp.bottom).offset(-8)
        }
    }
    
    fileprivate func setViewState() {
        switch self.pagingControl.currentPage {
        case 0:
            leftButton.isHidden = true
            rightButton.isHidden = false
            rightButton.setImage(UIImage(named: "nav_icon_dashboard"), for: .normal)
        case 1:
            leftButton.isHidden = false
            rightButton.isHidden = false
            rightButton.setImage(UIImage(named: "nav_icon_map"), for: .normal)
            leftButton.setImage(UIImage(named: "nav_icon_info"), for: .normal)
        case 2:
            leftButton.isHidden = false
            rightButton.isHidden = true
            leftButton.setImage(UIImage(named: "nav_icon_dashboard"), for: .normal)
        default: break
        }
        
        if self.titles.count >= self.pagingControl.currentPage, !titles.isEmpty {
            self.navTitle.text = self.titles[self.pagingControl.currentPage]
        }
    }
    
    private func setInitialPosition() {
        self.pagingControl.currentPage += 1
        self.mainActionView.contentOffset.x += self.frame.width
    }
    
}

extension BaseTopNavView: UIScrollViewDelegate {
    
    func moveScrollView(toFront: Bool) {
        if toFront {
            self.pagingControl.currentPage += 1
            self.animateTheMoving(action: {
                self.mainActionView.contentOffset.x += self.frame.width
            })
        } else {
            self.pagingControl.currentPage -= 1
            self.animateTheMoving(action: {
                self.mainActionView.contentOffset.x -= self.frame.width
            })
        }
        self.setViewState()
    }
    
    fileprivate func animateTheMoving(action:@escaping() -> Void, completion:((_ completed: Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: action, completion: { completed in completion?(completed)})
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.mainActionView.frame.width > 0 {
            let currentPage = Int(floor((self.mainActionView.contentOffset.x - (mainActionView.frame.width / 2 )) / ( mainActionView.frame.width) + 1))
            self.pagingControl.currentPage = currentPage
            self.setViewState()
        }
    }
}
