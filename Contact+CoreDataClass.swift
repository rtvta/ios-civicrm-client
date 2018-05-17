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
        let label = self.email ?? "\(firstName) \(lastName)"
        return "\(label)"
    }
    
    var entityTitle: String {
        return EntityMap.Contact.entityTitle
    }

    var contactName: String {
        let name = self.firstName ?? (self.lastName ?? (self.email ?? "(No Name)"))
        return "\(name)"
    }
    
    lazy var  sortedRelationsArray = {() -> Array<[NSManagedObject]> in
        var arr =  Array<[NSManagedObject]>()
        var person = Array<NSManagedObject>()
        person.append(self)
        arr.append(person)
        
        let contributionSortDescr = NSSortDescriptor(key: "contributionId", ascending: false)
        let participantSortDescr = NSSortDescriptor(key: "eventStartDate", ascending: false)
        let pledgeSortDescr = NSSortDescriptor(key: "startDate", ascending: false)
        
        if  let contributions = self.contribution?.sortedArray(using: [contributionSortDescr]) as? Array<NSManagedObject>, contributions.count > 0 {
            arr.append(contributions)
        }
        if let participants = self.participant?.sortedArray(using: [participantSortDescr]) as? Array<NSManagedObject>, participants.count > 0 {
            arr.append(participants)
        }
        if let pledges = self.pledge?.sortedArray(using: [pledgeSortDescr]) as? Array<NSManagedObject>, pledges.count > 0 {
            arr.append(pledges)
        }
        return arr
    }
}

