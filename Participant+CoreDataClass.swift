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
public class Participant: NSManagedObject, CiviCRMEntityDisplayed {
    
    var entityTitle: String {
        return EntityMap.Participant.entityTitle
    }
    
    var entityLable: String {
        let eventTitle = self.eventTitle ?? ""
        let eventType = self.eventType ?? ""
        return "\(eventTitle) - \(eventType)"
    }
    
    func getPropertiesForDisplayDictionary() -> [(String, String)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return [
            ("Event Name: ", "\(self.eventTitle ?? "(No Name)")"),
            ("Event Type: ", "\(self.eventType ?? "(No Type)")"),
            ("From Date: ", formatter.string(from: (self.eventStartDate! as Date))),
            ("To Date: ", formatter.string(from: (self.eventEndDate! as Date))),
            ("Fee Amount: ", "\(self.feeAmount) \(self.feeCurrency ?? "")"),
            ("Paid by: ", self.source ?? "(No Source)"),
            ("Your Role: ", self.role ?? "(No Role)"),
            ("Participant Status: ", self.status ?? "(No Status)"),
            ("Register Date: ", formatter.string(from: (self.registerDate! as Date))),
        ]
    }
    
}