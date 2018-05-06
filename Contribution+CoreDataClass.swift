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
            return "(No Source)"
        }
        return  source
    }

    func getPropertiesForDisplayDictionary() -> [(String, String)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return [
            ("For: ", "\(self.source ?? "(No Source)")"),
            ("Amount: ","\(self.totalAmount) \(self.currency ?? "")"),
            ("Paid by: ", self.paymentInstrument ?? ""),
            ("Recieve Date: ", formatter.string(from: (self.receiveDate! as Date))),
            ("Contribution Status: ", "\(self.status ?? "(No Status)")"),
        ]
    }
    
}
