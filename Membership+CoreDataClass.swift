//
//  Membership+CoreDataClass.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 21/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Membership)
public class Membership: NSManagedObject, CiviEntityDisplayed {
    // MARK: - Properties
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

    var entityLabel: String {
        let name = self.name ?? "(No Name)"
        return "\(name)"
    }
    
    var entityTitle: String {
        return "Your Membership(s)"
    }
    
    // MARK: - Functions
    func propertiesToDisplayList() -> Array<(String, String)> {
        let startDate: String = (self.startDate as Date?) != nil ? formatter.string(from: (self.startDate! as Date)) : ""
        let endDate: String = (self.endDate as Date?) != nil ? formatter.string(from: (self.endDate! as Date)) : ""
        let joinDate: String = (self.joinDate as Date?) != nil ? formatter.string(from: (self.joinDate! as Date)) : ""
        
        var displayList = Array<(String,String)>()
        
        displayList.append(("Membership:", "\(self.name ?? "(No Type)")"))
        displayList.append(("Member Since:", joinDate))
        displayList.append(("Start Date:", startDate))
        displayList.append(("End Date:", endDate))
        displayList.append(("Membership Status:", "\(self.status ?? "(No Status)")"))
        
        return displayList
    }
}
