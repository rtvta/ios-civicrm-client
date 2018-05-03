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
public class Pledge: NSManagedObject {
    
    override public var description: String {
        let totalPaid = self.totalPaid
        let totalAmount = self.totalAmount
        let currency = self.currency ?? ""
        return "\(totalPaid) \(currency) from \(totalAmount) \(currency)"
    }
}
