//
//  ContactScannerService.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import Foundation
import Contacts

protocol ContactScannerProviding {
    func fetchUserContacts() -> [CNContact]
    func requestPermissionForAccess(completion: @escaping (Bool) -> Void)
    func checkContact(phoneNumber: String, completion: @escaping((ContactCheckResult?) -> Void))
}

class ContactScannerService: ContactScannerProviding {
    
    private let network = NetworkLayer()
    
    func requestPermissionForAccess(completion: @escaping (Bool) -> Void) {
        CNContactStore().requestAccess(for: .contacts) { (granted, error) in
            completion(granted)
        }
    }

    func fetchUserContacts() -> [CNContact] {
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])

        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                contacts.append(contact)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return contacts
    }
    
    func checkContact(phoneNumber: String, completion: @escaping((ContactCheckResult?) -> Void)) {
        let url = URL(string: "https://eosmate.io:9090/api/v1/contacts/check_contact")!
        network.post(url: url, body: ["phone": phoneNumber]) { (data, error) in
            guard let data = data else { return completion(ContactCheckResult(phone: phoneNumber, status: .unknown)) }
            completion(try? JSONDecoder().decode(ContactCheckResult.self, from: data))
        }
    }
}
