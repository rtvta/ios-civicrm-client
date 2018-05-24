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
public class Contact: NSManagedObject, CiviEntityDisplayed {
    var alreadyViewed: Bool {
        set {
            self.notYetViewed = !newValue
        }
        get {
            return !notYetViewed
        }
    }
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter
    }()
    
    func propertiesForDisplay() -> [(String, String)] {
        
//        var formatter = DateFormatter()
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
    
    var entityLabel: String {
        let lastName = self.lastName ?? ""
        let firstName = self.firstName ?? ""
        let label = self.email ?? "\(firstName) \(lastName)"
        return "\(label)"
    }
    
    var entityTitle: String {
        return "Summary"
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
        
        let chageDateSortDescr = NSSortDescriptor(key: "changeDate", ascending: false)
        let notYetViewedSortDescr = NSSortDescriptor(key: "notYetViewed", ascending: false)
        let contributionSortDescr = NSSortDescriptor(key: "rowId", ascending: false)
        let participantSortDescr = NSSortDescriptor(key: "eventStartDate", ascending: false)
        let pledgeSortDescr = NSSortDescriptor(key: "startDate", ascending: false)
        let membershipSortDescr = NSSortDescriptor(key: "startDate", ascending: false)
  
        if let participants = self.participant?.sortedArray(using: [notYetViewedSortDescr, chageDateSortDescr, participantSortDescr]) as? Array<NSManagedObject>,
            participants.count > 0 {
            arr.append(participants)
        }
        if let pledges = self.pledge?.sortedArray(using: [notYetViewedSortDescr, chageDateSortDescr, pledgeSortDescr]) as? Array<NSManagedObject>,
            pledges.count > 0 {
            arr.append(pledges)
        }
        if let memberships = self.membership?.sortedArray(using: [chageDateSortDescr, membershipSortDescr]) as? Array<NSManagedObject>,
            memberships.count > 0 {
            arr.append(memberships)
        }
        if  let contributions = self.contribution?.sortedArray(using: [notYetViewedSortDescr, chageDateSortDescr, contributionSortDescr]) as? Array<NSManagedObject>,
            contributions.count > 0 {
            arr.append(contributions)
        }
        return arr
    }
}

