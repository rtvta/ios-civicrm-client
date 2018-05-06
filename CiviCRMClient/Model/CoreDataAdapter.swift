//
//  CoreDataAdapter.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 01/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import Foundation
import CoreData

class CoreDataAdapter {
    // MARK: - Class Properties
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var managedContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        managedContext = context
    }
    
    func insertSampleData() {
        
        let path = Bundle.main.path(forResource: "DemoCiviCRMData", ofType: "plist")
        
        let sampleData = NSDictionary(contentsOfFile: path!)!

       
        let contactId = upsert(message: sampleData)
        
        print("Contact Id == \(contactId) has been inserted successfuly")
    }
    
    // Upsert
    func upsert(message: NSDictionary) -> NSNumber {
        
        guard case let contactId as NSNumber = message["id"] else {
            return 0
        }
        
        var contactMO: Contact
        
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetch.predicate = NSPredicate(format: "contactId == %@", contactId)
        let result = try! managedContext.fetch(fetch)
        
        if result.count > 0 {
            contactMO = result.first!
        } else {
            let contactEntity = NSEntityDescription.entity(forEntityName: EntityMap.Contact.rawValue, in: managedContext)!
            contactMO = Contact(entity: contactEntity, insertInto: managedContext)
        }

        // Contact
        if let contactsDict = message[EntityMap.Contact.propertySet] as? NSDictionary, let contact = contactsDict.object(forKey: "\(contactId)") as? NSDictionary {
            
            contactMO.contactId = contact.value(forKey: ContactFields.contactId.rawValue) as! Int32
            contactMO.addressId = contact.value(forKey: ContactFields.addressId.rawValue) as! Int32
            contactMO.lastName = contact.value(forKey: ContactFields.lastName.rawValue) as? String
            contactMO.firstName = contact.value(forKey: ContactFields.firstName.rawValue) as? String
            contactMO.email = contact.value(forKey: ContactFields.email.rawValue) as? String
            contactMO.emailId = contact.value(forKey: ContactFields.emailId.rawValue) as! Int32
            contactMO.phone = contact.value(forKey: ContactFields.phone.rawValue) as? String
            contactMO.phoneId = contact.value(forKey: ContactFields.phoneId.rawValue) as! Int32
            contactMO.country = contact.value(forKey: ContactFields.country.rawValue) as? String
            contactMO.contactType = contact.value(forKey: ContactFields.contactType.rawValue) as? String
            contactMO.streetAddress = contact.value(forKey: ContactFields.streetAddress.rawValue) as? String
            contactMO.city = contact.value(forKey: ContactFields.city.rawValue) as? String
            if let birthDateString = contact.value(forKey: ContactFields.birthDate.rawValue) as? String, let birthDate = dateFormatter.date(from: birthDateString) {
                contactMO.birthDate = birthDate as NSDate
            }
            
            // Contributions
            if let contributionsDict = contact.value(forKey: EntityMap.Contribution.asAPIChain) as? NSDictionary,
                let contributions = contributionsDict[EntityMap.Contribution.propertySet] as? [NSDictionary] {
                        
                var contributionMO: Contribution
                var contributionId: NSNumber
                var contribution: NSDictionary
                
                for i in 0..<contributions.count {
                    contribution = contributions[i]
                    contributionId = contribution["id"] as! NSNumber
                    
                    let fetch: NSFetchRequest<Contribution> = Contribution.fetchRequest()
                    fetch.predicate = NSPredicate(format: "contributionId == %@", contributionId)
                    let result = try! managedContext.fetch(fetch)
                    
                    if result.count > 0 {
                        contributionMO = result.first!
                    } else {
                        let contributionEntity = NSEntityDescription.entity(forEntityName: EntityMap.Contribution.rawValue, in: managedContext)!
                        contributionMO = Contribution(entity: contributionEntity, insertInto: managedContext)
                    }
                    
                    contributionMO.contactId = contribution.value(forKey: ContributionFields.contactId.rawValue) as! Int32
                    contributionMO.contributionId = contribution.value(forKey: ContributionFields.contributionId.rawValue) as! Int32
                    contributionMO.source = contribution.value(forKey: ContributionFields.source.rawValue) as? String
                    contributionMO.status = contribution.value(forKey: ContributionFields.status.rawValue) as? String
                    contributionMO.currency = contribution.value(forKey: ContributionFields.currency.rawValue) as? String
                    contributionMO.totalAmount = contribution.value(forKey: ContributionFields.totalAmount.rawValue) as! Double
                    contributionMO.paymentInstrument = contribution.value(forKey: ContributionFields.paymentInstrument.rawValue) as? String
                    if let receiveDateStr = contribution.value(forKey: ContributionFields.receiveDate.rawValue) as? String, let receiveDate = dateFormatter.date(from: receiveDateStr) {
                        contributionMO.receiveDate = receiveDate as NSDate
                    }
                    contributionMO.contact = contactMO
                }
            }

            // Participants
            if let participantDict = contact.value(forKey: EntityMap.Participant.asAPIChain) as? NSDictionary,
                let participants = participantDict[EntityMap.Participant.propertySet] as? [NSDictionary] {
                        
                var participantMO: Participant
                var participantId: NSNumber
                var participant: NSDictionary
                
                for i in 0..<participants.count {
                    participant = participants[i]
                    participantId = participant["id"] as! NSNumber
                    
                    let fetch: NSFetchRequest<Participant> = Participant.fetchRequest()
                    fetch.predicate = NSPredicate(format: "participantId == %@", participantId)
                    let result = try! managedContext.fetch(fetch)
                    
                    if result.count > 0 {
                        participantMO = result.first!
                    } else {
                        let participantEntity = NSEntityDescription.entity(forEntityName: EntityMap.Participant.rawValue, in: managedContext)!
                        participantMO = Participant(entity: participantEntity, insertInto: managedContext)
                    }
                    
                    participantMO.contactId = participant.value(forKey: ParticipantFields.contactId.rawValue) as! Int32
                    participantMO.participantId = participant.value(forKey: ParticipantFields.participantId.rawValue) as! Int32
                    participantMO.eventId = participant.value(forKey: ParticipantFields.eventId.rawValue) as! Int32
                    participantMO.eventTitle = participant.value(forKey: ParticipantFields.eventTitle.rawValue) as? String
                    participantMO.eventType = participant.value(forKey: ParticipantFields.eventType.rawValue) as? String
                    participantMO.source = participant.value(forKey: ParticipantFields.source.rawValue) as? String
                    participantMO.status = participant.value(forKey: ParticipantFields.status.rawValue) as? String
                    participantMO.role = participant.value(forKey: ParticipantFields.role.rawValue) as? String
                    participantMO.feeCurrency = participant.value(forKey: ParticipantFields.feeCurrency.rawValue) as? String
                    participantMO.feeLevel = participant.value(forKey: ParticipantFields.feeLevel.rawValue) as? String
                    participantMO.feeAmount = participant.value(forKey: ParticipantFields.feeAmount.rawValue) as! Double
                    if let registerDateStr = participant.value(forKey: ParticipantFields.registerDate.rawValue) as? String, let registerDate = dateFormatter.date(from: registerDateStr) {
                        participantMO.registerDate = registerDate as NSDate
                    }
                    if let eventEndDateStr = participant.value(forKey: ParticipantFields.eventEndDate.rawValue) as? String, let eventEndDate = dateFormatter.date(from: eventEndDateStr) {
                        participantMO.eventEndDate = eventEndDate as NSDate
                    }
                    if let eventStartDateStr = participant.value(forKey: ParticipantFields.eventStartDate.rawValue) as? String, let eventStartDate = dateFormatter.date(from: eventStartDateStr) {
                        participantMO.eventStartDate = eventStartDate as NSDate
                    }
                    participantMO.contact = contactMO
                }
            }
            
            // Pledge
            if let pledgeDict = contact.value(forKey: EntityMap.Pledge.asAPIChain) as? NSDictionary,
                let pledges = pledgeDict[EntityMap.Pledge.propertySet] as? [NSDictionary] {
                
                var pledgeMO: Pledge
                var pledgeId: NSNumber
                var pledge: NSDictionary
                
                for i in 0..<pledges.count {
                    pledge = pledges[i]
                    pledgeId = pledge["id"] as! NSNumber
                    
                    let fetch: NSFetchRequest<Pledge> = Pledge.fetchRequest()
                    fetch.predicate = NSPredicate(format: "pledgeId == %@", pledgeId)
                    let result = try! managedContext.fetch(fetch)
                    
                    if result.count > 0 {
                        pledgeMO = result.first!
                    } else {
                        let pledgeEntity = NSEntityDescription.entity(forEntityName: EntityMap.Pledge.rawValue, in: managedContext)!
                        pledgeMO = Pledge(entity: pledgeEntity, insertInto: managedContext)
                    }
                    
                    pledgeMO.contactId = pledge.value(forKey: PledgeFields.contactId.rawValue) as! Int32
                    pledgeMO.pledgeId = pledge.value(forKey: PledgeFields.pledgeId.rawValue) as! Int32
                    pledgeMO.totalAmount = pledge.value(forKey: PledgeFields .totalAmount.rawValue) as! Double
                    pledgeMO.totalPaid = pledge.value(forKey: PledgeFields.totalPaid.rawValue) as! Double
                    pledgeMO.currency = pledge.value(forKey: PledgeFields.currency.rawValue) as? String
                    pledgeMO.financialType = pledge.value(forKey: PledgeFields.financialType.rawValue) as? String
                    pledgeMO.frequencyUnit = pledge.value(forKey: PledgeFields.frequencyUnit.rawValue) as? String
                    pledgeMO.status = pledge.value(forKey: PledgeFields.status.rawValue) as? String
                    pledgeMO.nextPayAmount = pledge.value(forKey: PledgeFields.nextPayAmount.rawValue) as! Double
                    if let startDateStr = pledge.value(forKey: PledgeFields.startDate.rawValue) as? String, let startDate = dateFormatter.date(from: startDateStr) {
                        pledgeMO.startDate = startDate as NSDate
                    }
                    if let nextPayDateStr = pledge.value(forKey: PledgeFields.nextPayDate.rawValue) as? String, let nextPayDate = dateFormatter.date(from: nextPayDateStr) {
                        pledgeMO.nextPayDate = nextPayDate as NSDate
                    }
                    pledgeMO.contact = contactMO
                }
            }
        }
        
        try! managedContext.save()
        
        return contactId
    }
    
        
    func deleteFirst() -> Bool {
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        let result = try! managedContext.fetch(fetch)
        
        guard result.count > 0, let contact = result.first else {
             return false
        }
        managedContext.delete(contact)
        try! managedContext.save()

        return true
    }

}
