//
//  Contribution+CoreDataProperties.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 02/06/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData


extension Contribution {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contribution> {
        return NSFetchRequest<Contribution>(entityName: "Contribution")
    }

    @NSManaged public var changeDate: NSDate?
    @NSManaged public var contactId: Int64
    @NSManaged public var currency: String?
    @NSManaged public var notYetViewed: Bool
    @NSManaged public var payInstrument: String?
    @NSManaged public var payInstrumentId: NSNumber?
    @NSManaged public var receiptDate: NSDate?
    @NSManaged public var receiveDate: NSDate?
    @NSManaged public var rowId: Int64
    @NSManaged public var source: String?
    @NSManaged public var status: String?
    @NSManaged public var totalAmount: Double
    @NSManaged public var statusId: Int64
    @NSManaged public var contact: Contact?

}
