//
//  Contact+CoreDataProperties.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 16/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var addressId: Int64
    @NSManaged public var birthDate: NSDate?
    @NSManaged public var city: String?
    @NSManaged public var contactId: Int64
    @NSManaged public var contactType: String?
    @NSManaged public var country: String?
    @NSManaged public var email: String?
    @NSManaged public var emailId: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phone: String?
    @NSManaged public var phoneId: Int64
    @NSManaged public var streetAddress: String?
    @NSManaged public var contribution: NSSet?
    @NSManaged public var participant: NSSet?
    @NSManaged public var pledge: NSSet?

}

// MARK: Generated accessors for contribution
extension Contact {

    @objc(addContributionObject:)
    @NSManaged public func addToContribution(_ value: Contribution)

    @objc(removeContributionObject:)
    @NSManaged public func removeFromContribution(_ value: Contribution)

    @objc(addContribution:)
    @NSManaged public func addToContribution(_ values: NSSet)

    @objc(removeContribution:)
    @NSManaged public func removeFromContribution(_ values: NSSet)

}

// MARK: Generated accessors for participant
extension Contact {

    @objc(addParticipantObject:)
    @NSManaged public func addToParticipant(_ value: Participant)

    @objc(removeParticipantObject:)
    @NSManaged public func removeFromParticipant(_ value: Participant)

    @objc(addParticipant:)
    @NSManaged public func addToParticipant(_ values: NSSet)

    @objc(removeParticipant:)
    @NSManaged public func removeFromParticipant(_ values: NSSet)

}

// MARK: Generated accessors for pledge
extension Contact {

    @objc(addPledgeObject:)
    @NSManaged public func addToPledge(_ value: Pledge)

    @objc(removePledgeObject:)
    @NSManaged public func removeFromPledge(_ value: Pledge)

    @objc(addPledge:)
    @NSManaged public func addToPledge(_ values: NSSet)

    @objc(removePledge:)
    @NSManaged public func removeFromPledge(_ values: NSSet)

}
