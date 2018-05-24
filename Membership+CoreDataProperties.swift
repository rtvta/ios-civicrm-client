//
//  Membership+CoreDataProperties.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 24/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData


extension Membership {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Membership> {
        return NSFetchRequest<Membership>(entityName: "Membership")
    }

    @NSManaged public var contactId: Int64
    @NSManaged public var endDate: NSDate?
    @NSManaged public var joinDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var rowId: Int64
    @NSManaged public var startDate: NSDate?
    @NSManaged public var status: String?
    @NSManaged public var notYetViewed: Bool
    @NSManaged public var changeDate: NSDate?
    @NSManaged public var contact: Contact?

}
