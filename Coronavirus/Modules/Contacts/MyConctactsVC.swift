//
//  MyConctactsVC.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit

class MyContactsVC: BaseVC {
    
    private let contactsView = MyContactsView(frame: kBaseTopNavScreenSize)
    private var contacts: [MyContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    override func loadView() {
        self.view = contactsView
    }
    
    private func bindView() {
        contactsView.didTapScan = { [weak self] in
            self?.requestPermission()
        }
    }
    
    private func requestPermission() {
        services.contactScannerProviding.requestPermissionForAccess { (accessGranted) in
            DispatchQueue.main.async {            
                self.fetchUsersContacts()
                self.updateContactStatuses()
            }
        }
    }
    
    private func fetchUsersContacts() {
        contacts = services.contactScannerProviding
            .fetchUserContacts()
            .map({
                let fullName = $0.givenName + " " + $0.familyName
                return MyContact(fullName: fullName, phone: $0.phoneNumbers.first?.value.stringValue ?? "", result: .clear)
            })
        
        contactsView.scannedContacts = contacts
    }
    
    private func updateContactStatuses() {
        contactsView.updatingStatuses()
        contacts.forEach { (contact) in
            print(contact.phone)
            services.contactScannerProviding.checkContact(phoneNumber: contact.phone) { (scanResult) in
                contact.result = scanResult?.status ?? .unknown
                
                DispatchQueue.main.async {                
                    self.contactsView.update(contact: contact)
                }
            }
        }
        
    }
    
}
