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
    // MARK: - Properties
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
        
        let sortByRowIdDesc = [NSSortDescriptor(key: "rowId", ascending: false)]
        
        if  let contributions = self.contribution?.sortedArray(using: sortByRowIdDesc) as? Array<NSManagedObject>,
            contributions.count > 0 {
            arr.append(contributions)
        }
        
        if let pledges = self.pledge?.sortedArray(using: sortByRowIdDesc) as? Array<NSManagedObject>,
            pledges.count > 0 {
            arr.append(pledges)
        }
        
        if let participants = self.participant?.sortedArray(using: sortByRowIdDesc) as? Array<NSManagedObject>,
            participants.count > 0 {
            arr.append(participants)
        }
        
        if let memberships = self.membership?.sortedArray(using: sortByRowIdDesc) as? Array<NSManagedObject>,
            memberships.count > 0 {
            arr.append(memberships)
        }
        
        return arr
    }
    
    // MARK: - Functions
    func propertiesToDisplayList() -> Array<(String, String)> {
        formatter.dateFormat = "MMM dd yyyy"
        let birthDate: String = (self.birthDate as Date?) != nil ? formatter.string(from: (self.birthDate! as Date)) : ""
        var new: Int = 0
        
        var displayList = Array<(String,String)>()
       
        if let relation = self.contribution as? Set<Contribution>, relation.count > 0 {
            for r in relation where r.notYetViewed {
                new += 1
            }
            displayList.append(("Contribution(s):", "\(relation.count) / \(new)"))
            new = 0
        }
        
        if let relation = self.pledge as? Set<Pledge>, relation.count > 0 {
            for r in relation where r.notYetViewed {
                new += 1
            }
            displayList.append(("Plegde(s):", "\(relation.count) / \(new)"))
            new = 0
        }
        
        if let relation = self.participant as? Set<Participant>, relation.count > 0 {
            for r in relation where r.notYetViewed {
                new += 1
            }
            displayList.append(("Events(s):", "\(relation.count) / \(new)"))
            new = 0
        }
        
        if let relation = self.membership as? Set<Membership>, relation.count > 0 {
            for r in relation where r.notYetViewed {
                new += 1
            }
            displayList.append(("Membership(s):", "\(relation.count) / \(new)"))
            new = 0
        }
        
        displayList.append(("First Name:", "\(self.firstName ?? "(No Name)")"))
        displayList.append(("Last Name:", "\(self.lastName ?? "(No Name)")"))
        displayList.append(("Email:", "\(self.email ?? "(No Email)")"))
        displayList.append(("Phone:", "\(self.phone ?? "(No Phone)")"))
        displayList.append(("Address:", "\(self.streetAddress ?? "(No Address)")"))
        displayList.append(("Birth Date:", birthDate))
        displayList.append(("Gender:", "\(self.gender ?? "")"))
        displayList.append(("City:", "\(self.city ?? "")"))
        displayList.append(("Country:", "\(self.country ?? "")"))
        displayList.append(("State Province:", "\(self.provinceName ?? "")"))
        
        return displayList
    }
}

