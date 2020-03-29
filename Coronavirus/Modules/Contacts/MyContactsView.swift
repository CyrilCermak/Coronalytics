//
//  MyContactsView.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 28.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

class MyContactsView: BaseViewWithTableView {

    var didTapAt: ((MyContact) -> Void)?
    var didTapScan: (() -> Void)?
    var scannedContacts: [MyContact]? { didSet { reloadData() } }
    private var updatingRow = [String: Int]()
    
    private var scanButton: CVButton = {
        let btn = CVButton(title: "SCAN CONTACT")
        btn.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        tableView.clipsToBounds = true
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    private func setButton() {
        addSubview(scanButton)
        scanButton.snp.makeConstraints { (make) in
            make.height.equalTo(48)
            make.bottom.equalTo(self.safeAreaInsets.bottom).offset(-74)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannedContacts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as? ContactCell else {
            assertionFailure("Could dequeue Contact cell")
            return UITableViewCell()
        }
        
        guard let scannedContact = scannedContacts?[indexPath.row] else {
            assertionFailure("Could not get a model for a cell")
            return UITableViewCell()
        }
        
        cell.set(model: scannedContact, updating: updatingRow[scannedContact.phone] != nil)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    @objc func scanButtonTapped() {
        didTapScan?()
    }
    
    func updatingStatuses() {
        scannedContacts?.enumerated().forEach({ (index, contact) in
            updatingRow[contact.phone] = index
        })
        tableView.reloadData()
    }
    
    func update(contact: MyContact) {
        if let index = updatingRow[contact.phone] {
            updatingRow[contact.phone] = nil
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }

}
