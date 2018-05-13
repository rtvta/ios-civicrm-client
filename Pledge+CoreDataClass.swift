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
        let frequencyInterval = self.frequencyInterval
        return "\(financialType): every \(frequencyInterval) \(frequencyUnit)"
    }
    
    func getPropertiesForDisplayDictionary() -> [(String, String)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        let startDate: String = (self.startDate as Date?) != nil ? formatter.string(from: (self.startDate! as Date)) : ""
        let nextPayDate: String = (self.nextPayDate as Date?) != nil ? formatter.string(from: (self.nextPayDate! as Date)) : ""
        
        return [
            ("Payment for: ", "\(self.financialType ?? "(No Data)")"),
            ("Total Amount: ","\(self.totalAmount) \(self.currency ?? "")"),
            ("Start Date: ", startDate),
            ("Status: ", "\(self.status ?? "(No Status)")"),
            ("Frequency: ", "per \(self.frequencyInterval) \(self.frequencyUnit ?? "(No Frequency)")"),
            ("Total Paid: ", "\(self.totalPaid) \(self.currency ?? "")"),
            ("Next Amount: ", "\(self.nextPayAmount) \(self.currency ?? "")"),
            ("Next Date: ", nextPayDate),
        ]
    }
}
