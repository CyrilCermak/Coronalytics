//
//  BaseTableView.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class BaseViewWithTableView: UIView {
    
    let tableView = UITableView()
    var didChangeRefreshingState: ((Bool) -> Void)?
    var cells: [UITableViewCell] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.cvCyan
        refreshControl.addTarget(self, action: #selector(didChangeState), for: .valueChanged)
        return refreshControl
    }()
    
    required init?(coder aDecoder: NSCoder) { fatalError("coeder not implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTableView()
    }
    
    func initTableView() {
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func startRefreshing() {
        self.tableView.refreshControl = refreshControl
        self.refreshControl.tintColor = UIColor.white
        self.tableView.contentOffset = CGPoint(x:0, y: -self.refreshControl.frame.size.height)
        self.refreshControl.beginRefreshing()
    }
    
    func stopRefreshing() {
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        refreshControl.endRefreshing()
    }
    
    func reloadData() {
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint(x:0, y: 0), animated: true)
        self.refreshControl.endRefreshing()
    }
    
    func registerCell(for aClass: AnyClass, id: String) {
        self.tableView.register(aClass, forCellReuseIdentifier: id)
    }
    
    @objc func didChangeState() {
        didChangeRefreshingState?(refreshControl.isRefreshing)
    }
    
}

extension BaseViewWithTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = cells[indexPath.row] as? HeightProviding {
            return cell.height
        }
        return UITableView.automaticDimension
    }
}
