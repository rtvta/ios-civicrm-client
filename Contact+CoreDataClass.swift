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
        formatter.dateFormat = "MMM dd yyyy"
        let birthDate: String = (self.birthDate as Date?) != nil ? formatter.string(from: (self.birthDate! as Date)) : ""
        
        return [
            ("First Name: ", "\(self.firstName ?? "(No Name)")"),
            ("Last Name: ", "\(self.lastName ?? "(No Name)")"),
            ("Birth Date: ", birthDate),
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
    
    lazy var  relationsArray = {() -> [NSOrderedSet] in
        var arr: Array = [NSOrderedSet]()
        var person = NSMutableOrderedSet()
        person[0] = self
        arr.append(person)
      
        if  let contributions = self.contribution, contributions.count > 0 {
            arr.append(contributions)
        }
        if let participants = self.participant, participants.count > 0 {
            arr.append(participants)
        }
        if let pledges = self.pledge, pledges.count > 0 {
            arr.append(pledges)
        }
        return arr
    }
}

