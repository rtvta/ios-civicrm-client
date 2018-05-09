//
//  Contact+CoreDataClass.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 29/04/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject, CiviCRMEntityDisplayed {
    func getPropertiesForDisplayDictionary() -> [(String, String)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return [
            ("First Name: ", "\(self.firstName ?? "(No Name)")"),
            ("Last Name: ", "\(self.lastName ?? "(No Name)")"),
//            ("Birth Date: ", formatter.string(from: (self.birthDate! as Date))),
            ("Email: ", "\(self.email ?? "(No Email)")"),
            ("Phone: ", "\(self.phone ?? "(No Phone)")"),
            ("Address: ", "\(self.streetAddress ?? "(No Address)")"),
            ("City: ", "\(self.city ?? "(No City)")"),
            ("Country: ", "\(self.country ?? "(No Country)")"),
        ]
    }
    
    var entityLable: String {
        let lastName = self.lastName ?? ""
        let firstName = self.firstName ?? ""
        return "\(firstName) \(lastName)"
    }
    
    var entityTitle: String {
        return EntityMap.Contact.entityTitle
    }
    
    
}

