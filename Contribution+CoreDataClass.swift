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
public class Contribution: NSManagedObject, CiviCRMEntityDisplayed {
    
    var entityTitle: String {
        return EntityMap.Contribution.entityTitle
    }
    
    var entityLable: String {
        guard let source = self.source else {
            return "(No Description)"
        }
        if source.isEmpty {
            return "(No Description)"
        }
        return  source
    }

    func getPropertiesForDisplayDictionary() -> [(String, String)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        let receiveDate: String = (self.receiveDate as Date?) != nil ? formatter.string(from: (self.receiveDate! as Date)) : ""
        
        return [
            ("Paid for: ", "\(self.source ?? "(No Source)")"),
            ("Amount: ","\(self.totalAmount) \(self.currency ?? "")"),
            ("Paid by: ", self.paymentInstrument ?? ""),
            ("Recieve Date: ", receiveDate),
            ("Contribution Status: ", "\(self.status ?? "(No Status)")"),
        ]
    }
}
