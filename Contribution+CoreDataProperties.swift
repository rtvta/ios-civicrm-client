//
//  Contribution+CoreDataProperties.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 06/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData


extension Contribution {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contribution> {
        return NSFetchRequest<Contribution>(entityName: "Contribution")
    }

    @NSManaged public var contactId: Int32
    @NSManaged public var contributionId: Int32
    @NSManaged public var currency: String?
    @NSManaged public var paymentInstrument: String?
    @NSManaged public var receiveDate: NSDate?
    @NSManaged public var source: String?
    @NSManaged public var status: String?
    @NSManaged public var totalAmount: Double
    @NSManaged public var contact: Contact?

}
