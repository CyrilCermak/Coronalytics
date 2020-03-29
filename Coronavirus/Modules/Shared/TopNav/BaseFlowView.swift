//
//  BaseFlowView.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BaseFlowView: UIView {
    
    let mainActionView = UIScrollView()
    var titles = [String]() { didSet { self.setViewState(); pagingControl.numberOfPages = self.titles.count } }
    var rightBtnClicked: (() -> Void)?
    var leftBtnClicked: (() -> Void)?
    
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
        
        setTopNavView()
        setButtons()
        setMainActionView()
        setPageControl()
        setNavTitle()
        setViewState()
    }
    
    private func addViews() {
        [topNavView, mainActionView, leftButton, rightButton, pagingControl, navTitle].forEach({ self.addSubview($0) })
    }
    
    private func setTopNavView() {
        sendSubviewToBack(mainActionView)
        topNavView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(isIphoneX ? 88 : 64)
        }
    }
    
    private func setButtons() {
        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(isIphoneX ? 45 : 25)
            make.width.height.equalTo(25)
        }
        rightButton.setImage(UIImage(named: "btnCancelGrey"), for: .normal)
        
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.leftButton)
            make.width.height.equalTo(25)
        }
    }
    
    private func setMainActionView() {
        self.mainActionView.isScrollEnabled = true
        self.mainActionView.showsHorizontalScrollIndicator = false
        self.mainActionView.showsVerticalScrollIndicator = false
        self.mainActionView.clipsToBounds = false
        self.mainActionView.bounces = false
        self.mainActionView.isPagingEnabled = true
        self.mainActionView.delegate = self
        self.mainActionView.contentInsetAdjustmentBehavior = .never
        self.mainActionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setNavTitle() {
        self.navTitle.textAlignment = .center
        self.navTitle.font = UIFont.systemFont(ofSize: 16)
        self.navTitle.snp.makeConstraints { (make) in
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
        pagingControl.numberOfPages = self.titles.count
        
        pagingControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.topNavView)
            make.height.equalTo(10)
            make.bottom.equalTo(self.topNavView.snp.bottom).offset(-8)
        }
    }
    
    fileprivate func setViewState() {
        guard self.titles.count > 0 else { return }
        if self.titles.count >= self.pagingControl.currentPage {
            self.navTitle.text = self.titles[self.pagingControl.currentPage]
        }
    }
    
    func didScroll() {} //Override this to add action to the didScroll
}

extension BaseFlowView: UIScrollViewDelegate {
    
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
        self.didScroll()
        if self.mainActionView.frame.width > 0 {
            let currentPage = Int(floor((self.mainActionView.contentOffset.x - (mainActionView.frame.width / 2 )) / ( mainActionView.frame.width) + 1))
            self.pagingControl.currentPage = currentPage
            self.setViewState()
        }
    }
}
