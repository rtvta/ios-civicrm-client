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
        return "Your Contribution(s)"
    }
    
    var entityLabel: String {
        if  let source = self.source, !source.isEmpty {
            return  source
        }
        return "(No Description)"
    }

    // MARK: - Functions
    func propertiesToDisplayList() -> Array<(String, String)> {
        let receiveDate: String = (self.receiveDate as Date?) != nil ? formatter.string(from: (self.receiveDate! as Date)) : ""
        let receiptDate: String = (self.receiptDate as Date?) != nil ? formatter.string(from: (self.receiptDate! as Date)) : ""
        
        var displayList = Array<(String,String)>()
        
        displayList.append(("Paid for: ", "\(self.source ?? "(No Source)")"))
        displayList.append(("Amount: ","\(self.totalAmount) \(self.currency ?? "")"))
        displayList.append(("Paid by: ", self.payInstrument ?? ""))
        displayList.append(("Received Date: ", receiveDate))
        displayList.append(("Receipt Date: ", receiptDate))
        displayList.append(("Contribution Status: ", "\(self.status ?? "(No Status)")"))
        
        return displayList
    }
}
