//
//  Participant+CoreDataClass.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 29/04/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Participant)
public class Participant: NSManagedObject, CiviEntityDisplayed {
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
    
    var entityTitle: String {
        return "Your Event(s)"
    }
    
    var entityLabel: String {
        let eventTitle = self.eventTitle ?? "(No Event Title)"
        return "\(eventTitle)"
    }
    
    // MARK: - Functions
    func propertiesToDisplayList() -> Array<(String, String)> {
        formatter.dateFormat = "MMM dd yyyy"
        let registerDate: String = (self.registerDate as Date?) != nil ? formatter.string(from: (self.registerDate! as Date)) : ""
        formatter.dateFormat = "MMM dd yyyy hh:mm"
        let eventStartDate: String = (self.eventStartDate as Date?) != nil ? formatter.string(from: (self.eventStartDate! as Date)) : ""
        let eventEndDate: String = (self.eventEndDate as Date?) != nil ? formatter.string(from: (self.eventEndDate! as Date)) : ""
        let amount = self.feeAmount
        
        var displayList = Array<(String,String)>()
        
        displayList.append(("Event:", "\(self.eventTitle ?? "(No Name)")"))
        displayList.append(("Event Type:", "\(self.eventType ?? "(No Type)")"))
        displayList.append(("From Date:", eventStartDate))
        displayList.append(("To Date: ", eventEndDate))
        displayList.append(("Register Date:", registerDate))
        displayList.append(("Fee Amount:", "\(amount) \(self.feeCurrency ?? "")"))
        displayList.append(("Source:", self.source ?? "(No Source)"))
        displayList.append(("Role:", self.role ?? "(No Role)"))
        displayList.append(("Status:", self.status ?? "(No Status)"))
        
        return displayList
    }    
}
