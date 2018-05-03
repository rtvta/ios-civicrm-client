//
//  Participant+CoreDataProperties.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 01/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData


extension Participant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Participant> {
        return NSFetchRequest<Participant>(entityName: "Participant")
    }

    @NSManaged public var contactId: Int32
    @NSManaged public var eventEndDate: NSDate?
    @NSManaged public var eventId: Int32
    @NSManaged public var eventStartDate: NSDate?
    @NSManaged public var eventTitle: String?
    @NSManaged public var eventType: String?
    @NSManaged public var feeAmount: Double
    @NSManaged public var feeCurrency: String?
    @NSManaged public var feeLevel: String?
    @NSManaged public var participantId: Int32
    @NSManaged public var registerDate: NSDate?
    @NSManaged public var role: String?
    @NSManaged public var source: String?
    @NSManaged public var status: String?
    @NSManaged public var contact: Contact?

}
