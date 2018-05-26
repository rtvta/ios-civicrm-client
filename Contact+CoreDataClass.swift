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
    // MARK: Properties
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter
    }()
    
    
    var alreadyViewed: Bool {
        set {
            self.notYetViewed = !newValue
        }
        get {
            return !notYetViewed
        }
    }
 
    func propertiesForDisplay() -> Array<(String, String)> {
        var displayDetails = Array<(String,String)>()
        var new: Int = 0
        formatter.dateFormat = "MMM dd yyyy"
        let birthDate: String = (self.birthDate as Date?) != nil ? formatter.string(from: (self.birthDate! as Date)) : ""
        if let relation = self.participant as? Set<Participant> {
            for r in relation where r.notYetViewed {
                new += 1
            }
            displayDetails.append(("Events: ", "\(relation.count) / \(new)"))
            new = 0
        }
        
        if let relation = self.membership as? Set<Membership> {
            for r in relation where r.notYetViewed {
                new += 1
            }
            displayDetails.append(("Memberships: ", "\(relation.count) / \(new)"))
            new = 0
        }
        
        if let relation = self.pledge as? Set<Pledge> {
            for r in relation where r.notYetViewed {
                new += 1
            }
            displayDetails.append(("Plegdes: ", "\(relation.count) / \(new)"))
            new = 0
        }
        
        if let relation = self.contribution as? Set<Contribution> {
            for r in relation where r.notYetViewed {
                new += 1
            }
            displayDetails.append(("Contributions: ", "\(relation.count) / \(new)"))
            new = 0
        }
        
        displayDetails.append(("First Name: ", "\(self.firstName ?? "(No Name)")"))
        displayDetails.append(("Last Name: ", "\(self.lastName ?? "(No Name)")"))
        displayDetails.append(("Birth Date: ", birthDate))
        displayDetails.append(("Email: ", "\(self.email ?? "(No Email)")"))
        displayDetails.append(("Phone: ", "\(self.phone ?? "(No Phone)")"))
        displayDetails.append(("Address: ", "\(self.streetAddress ?? "(No Address)")"))
        displayDetails.append(("City: ", "\(self.city ?? "(No City)")"))
        displayDetails.append(("Country: ", "\(self.country ?? "(No Country)")"))
        
        return displayDetails
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

