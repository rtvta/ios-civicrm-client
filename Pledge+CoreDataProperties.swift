//
//  Pledge+CoreDataProperties.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 09/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData


extension Pledge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pledge> {
        return NSFetchRequest<Pledge>(entityName: "Pledge")
    }

    @NSManaged public var contactId: Int64
    @NSManaged public var currency: String?
    @NSManaged public var financialType: String?
    @NSManaged public var frequencyInterval: Int16
    @NSManaged public var frequencyUnit: String?
    @NSManaged public var nextPayAmount: Double
    @NSManaged public var nextPayDate: NSDate?
    @NSManaged public var pledgeId: Int64
    @NSManaged public var startDate: NSDate?
    @NSManaged public var status: String?
    @NSManaged public var totalAmount: Double
    @NSManaged public var totalPaid: Double
    @NSManaged public var contact: Contact?

}
