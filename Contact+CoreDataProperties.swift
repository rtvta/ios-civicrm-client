//
//  Contact+CoreDataProperties.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 09/05/2018.
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
    @NSManaged public var contribution: NSOrderedSet?
    @NSManaged public var participant: NSOrderedSet?
    @NSManaged public var pledge: NSOrderedSet?

}

// MARK: Generated accessors for contribution
extension Contact {

    @objc(insertObject:inContributionAtIndex:)
    @NSManaged public func insertIntoContribution(_ value: Contribution, at idx: Int)

    @objc(removeObjectFromContributionAtIndex:)
    @NSManaged public func removeFromContribution(at idx: Int)

    @objc(insertContribution:atIndexes:)
    @NSManaged public func insertIntoContribution(_ values: [Contribution], at indexes: NSIndexSet)

    @objc(removeContributionAtIndexes:)
    @NSManaged public func removeFromContribution(at indexes: NSIndexSet)

    @objc(replaceObjectInContributionAtIndex:withObject:)
    @NSManaged public func replaceContribution(at idx: Int, with value: Contribution)

    @objc(replaceContributionAtIndexes:withContribution:)
    @NSManaged public func replaceContribution(at indexes: NSIndexSet, with values: [Contribution])

    @objc(addContributionObject:)
    @NSManaged public func addToContribution(_ value: Contribution)

    @objc(removeContributionObject:)
    @NSManaged public func removeFromContribution(_ value: Contribution)

    @objc(addContribution:)
    @NSManaged public func addToContribution(_ values: NSOrderedSet)

    @objc(removeContribution:)
    @NSManaged public func removeFromContribution(_ values: NSOrderedSet)

}

// MARK: Generated accessors for participant
extension Contact {

    @objc(insertObject:inParticipantAtIndex:)
    @NSManaged public func insertIntoParticipant(_ value: Participant, at idx: Int)

    @objc(removeObjectFromParticipantAtIndex:)
    @NSManaged public func removeFromParticipant(at idx: Int)

    @objc(insertParticipant:atIndexes:)
    @NSManaged public func insertIntoParticipant(_ values: [Participant], at indexes: NSIndexSet)

    @objc(removeParticipantAtIndexes:)
    @NSManaged public func removeFromParticipant(at indexes: NSIndexSet)

    @objc(replaceObjectInParticipantAtIndex:withObject:)
    @NSManaged public func replaceParticipant(at idx: Int, with value: Participant)

    @objc(replaceParticipantAtIndexes:withParticipant:)
    @NSManaged public func replaceParticipant(at indexes: NSIndexSet, with values: [Participant])

    @objc(addParticipantObject:)
    @NSManaged public func addToParticipant(_ value: Participant)

    @objc(removeParticipantObject:)
    @NSManaged public func removeFromParticipant(_ value: Participant)

    @objc(addParticipant:)
    @NSManaged public func addToParticipant(_ values: NSOrderedSet)

    @objc(removeParticipant:)
    @NSManaged public func removeFromParticipant(_ values: NSOrderedSet)

}

// MARK: Generated accessors for pledge
extension Contact {

    @objc(insertObject:inPledgeAtIndex:)
    @NSManaged public func insertIntoPledge(_ value: Pledge, at idx: Int)

    @objc(removeObjectFromPledgeAtIndex:)
    @NSManaged public func removeFromPledge(at idx: Int)

    @objc(insertPledge:atIndexes:)
    @NSManaged public func insertIntoPledge(_ values: [Pledge], at indexes: NSIndexSet)

    @objc(removePledgeAtIndexes:)
    @NSManaged public func removeFromPledge(at indexes: NSIndexSet)

    @objc(replaceObjectInPledgeAtIndex:withObject:)
    @NSManaged public func replacePledge(at idx: Int, with value: Pledge)

    @objc(replacePledgeAtIndexes:withPledge:)
    @NSManaged public func replacePledge(at indexes: NSIndexSet, with values: [Pledge])

    @objc(addPledgeObject:)
    @NSManaged public func addToPledge(_ value: Pledge)

    @objc(removePledgeObject:)
    @NSManaged public func removeFromPledge(_ value: Pledge)

    @objc(addPledge:)
    @NSManaged public func addToPledge(_ values: NSOrderedSet)

    @objc(removePledge:)
    @NSManaged public func removeFromPledge(_ values: NSOrderedSet)

}
