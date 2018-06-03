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
public class Pledge: NSManagedObject, CiviEntityDisplayed {
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
        return "Your Pledge(s)"
    }
    
    var entityLabel: String {
        let frequencyUnit = self.frequencyUnit ?? ""
        let financialType = self.financialType ?? ""
        let frequencyInterval = self.frequencyInterval
        return "\(financialType): Every \(frequencyInterval) \(frequencyUnit)"
    }
    
    // MARK: - Functions
    func propertiesToDisplayList() -> Array<(String, String)> {
        let startDate: String = (self.startDate as Date?) != nil ? formatter.string(from: (self.startDate! as Date)) : ""
        let nextPayDate: String = (self.nextPayDate as Date?) != nil ? formatter.string(from: (self.nextPayDate! as Date)) : ""
        
        var displayList = Array<(String,String)>()
        
        displayList.append(("Pledged:","\(self.totalAmount) \(self.currency ?? "")"))
        displayList.append(("Total Paid:", "\(self.totalPaid) \(self.currency ?? "")"))
        displayList.append(("Balance:", "\(self.totalAmount - self.totalPaid) \(self.currency ?? "")"))
        displayList.append(("Pledge for:", "\(self.financialType ?? "(No Data)")"))
        displayList.append(("Pledge Made:", startDate))
        displayList.append(("Frequency:", "every \(self.frequencyInterval) \(self.frequencyUnit ?? "(No Frequency)")"))
        displayList.append(("Next Pay Date:", nextPayDate))
        displayList.append(("Next Amount:", "\(self.nextPayAmount) \(self.currency ?? "")"))
        displayList.append(("Status:", "\(self.status ?? "(No Status)")"))
        
        return displayList
    }
}
