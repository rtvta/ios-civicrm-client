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
    var isNew: Bool = false
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter
    }()
    
    var entityTitle: String {
        return "Events"
    }
    
    var entityLabel: String {
        let eventTitle = self.eventTitle ?? ""
        let eventType = self.eventType ?? ""
        return "\(eventTitle) - \(eventType)"
    }
    
    func propertiesForDisplay() -> [(String, String)] {
        formatter.dateFormat = "MMM dd yyyy"
        let registerDate: String = (self.registerDate as Date?) != nil ? formatter.string(from: (self.registerDate! as Date)) : ""
        formatter.dateFormat = "MMM dd yyyy hh:mm"
        let eventStartDate: String = (self.eventStartDate as Date?) != nil ? formatter.string(from: (self.eventStartDate! as Date)) : ""
        let eventEndDate: String = (self.eventEndDate as Date?) != nil ? formatter.string(from: (self.eventEndDate! as Date)) : ""
        
        return [
            ("Event Name: ", "\(self.eventTitle ?? "(No Name)")"),
            ("Event Type: ", "\(self.eventType ?? "(No Type)")"),
            ("From Date: ", eventStartDate),
            ("To Date: ", eventEndDate),
            ("Fee Amount: ", "\(self.feeAmount) \(self.feeCurrency ?? "")"),
            ("Paid by: ", self.source ?? "(No Source)"),
            ("Your Role: ", self.role ?? "(No Role)"),
            ("Participant Status: ", self.status ?? "(No Status)"),
            ("Register Date: ", registerDate),
        ]
    }    
}
