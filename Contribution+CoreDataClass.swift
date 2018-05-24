//
//  Contribution+CoreDataClass.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 29/04/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Contribution)
public class Contribution: NSManagedObject, CiviEntityDisplayed {
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
        return "Payments"
    }
    
    var entityLabel: String {
        guard let source = self.source else {
            return "(No Description)"
        }
        if source.isEmpty {
            return "(No Description)"
        }
        return  source
    }

    func propertiesForDisplay() -> [(String, String)] {
        let receiveDate: String = (self.receiveDate as Date?) != nil ? formatter.string(from: (self.receiveDate! as Date)) : ""
        
        return [
            ("Paid for: ", "\(self.source ?? "(No Source)")"),
            ("Amount: ","\(self.totalAmount) \(self.currency ?? "")"),
            ("Paid by: ", self.payInstrument ?? ""),
            ("Recieve Date: ", receiveDate),
            ("Contribution Status: ", "\(self.status ?? "(No Status)")"),
        ]
    }
}
