//
//  Pledge+CoreDataClass.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 29/04/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pledge)
public class Pledge: NSManagedObject, CiviCRMEntityDisplayed {
    
    var entityTitle: String {
        return EntityMap.Pledge.entityTitle
    }
    
    var entityLable: String {
        let frequencyUnit = self.frequencyUnit ?? ""
        let financialType = self.financialType ?? ""
        return "\(financialType): every \(frequencyUnit)"
    }
    
    func getPropertiesForDisplayDictionary() -> [(String, String)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return [
            ("Payment for: ", "\(self.financialType ?? "(No Data)")"),
            ("Total Amount: ","\(self.totalAmount) \(self.currency ?? "")"),
            ("Start Date: ", formatter.string(from: (self.startDate! as Date))),
            ("Status: ", "\(self.status ?? "(No Status)")"),
            ("Frequency: ", "\(self.frequencyUnit ?? "(No Frequency)")"),
            ("Total Paid: ", "\(self.totalPaid) \(self.currency ?? "")"),
            ("Next Amount: ", "\(self.nextPayAmount) \(self.currency ?? "")"),
            ("Next Date: ", formatter.string(from: (self.nextPayDate! as Date))),
        ]
    }
    
}
