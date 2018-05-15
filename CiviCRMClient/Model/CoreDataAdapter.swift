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
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var managedContext: NSManagedObjectContext
    
    // MARK: - Init
    init(context: NSManagedObjectContext) {
        managedContext = context
    }
    
    // MARK: - Functions
    // Insert Sample Data
    func insertSampleData() {
        print("Insert Sample Data")
        let path = Bundle.main.path(forResource: "DemoCiviCRMData", ofType: "plist")
        let sampleData = NSDictionary(contentsOfFile: path!)!
        let id = sampleData.value(forKey: "id") as! NSNumber
        let _ = upsert(for: id, message: sampleData)
    }
    

    
    // Upsert context from message
    func upsert(for contactId: NSNumber, message: NSDictionary) {
        
        // Check if contact already exists in database
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
            
            setValuesContactMO(contactMO, contact)
            
            // Contributions
            if let contributionsDict = contact.value(forKey: EntityMap.Contribution.asAPIChain) as? NSDictionary,
                let contributions = contributionsDict[EntityMap.Contribution.propertySet] as? [NSDictionary] {

                for i in 0..<contributions.count {
                    
                    guard let id = Int(contributions[i].value(forKey: "id") as! String) as NSNumber? else {
                        continue
                    }
                    
                    let contributionMO: Contribution
                    let fetch: NSFetchRequest<Contribution> = Contribution.fetchRequest()
                    fetch.predicate = NSPredicate(format: "contributionId == %@", id)
                    let result = try! managedContext.fetch(fetch)
                    
                    if result.count > 0 {
                        contributionMO = result.first!
                    } else {
                        let contributionEntity = NSEntityDescription.entity(forEntityName: EntityMap.Contribution.rawValue, in: managedContext)!
                        contributionMO = Contribution(entity: contributionEntity, insertInto: managedContext)
                    }
                    
                    setValuesContributionMO(contributionMO, contributions[i])
                    contributionMO.contact = contactMO
                }
            }

            // Participants
            if let participantDict = contact.value(forKey: EntityMap.Participant.asAPIChain) as? NSDictionary,
                let participants = participantDict[EntityMap.Participant.propertySet] as? [NSDictionary] {
         
                for i in 0..<participants.count {
                    
                    guard let id = Int(participants[i].value(forKey: "id") as! String) as NSNumber? else {
                        continue
                    }
                    
                    let participantMO: Participant
                    let fetch: NSFetchRequest<Participant> = Participant.fetchRequest()
                    fetch.predicate = NSPredicate(format: "participantId == %@", id)
                    let result = try! managedContext.fetch(fetch)
                    
                    if result.count > 0 {
                        participantMO = result.first!
                    } else {
                        let participantEntity = NSEntityDescription.entity(forEntityName: EntityMap.Participant.rawValue, in: managedContext)!
                        participantMO = Participant(entity: participantEntity, insertInto: managedContext)
                    }
                    
                    setValuesParticipantMO(participantMO, participants[i])
                    participantMO.contact = contactMO
                }
            }
            
            // Pledge
            if let pledgeDict = contact.value(forKey: EntityMap.Pledge.asAPIChain) as? NSDictionary,
                let pledges = pledgeDict[EntityMap.Pledge.propertySet] as? [NSDictionary] {
        
                for i in 0..<pledges.count {
                    
                    guard let id = Int(pledges[i].value(forKey: "id") as! String) as NSNumber? else {
                        continue
                    }
                    
                    let pledgeMO: Pledge
                    let fetch: NSFetchRequest<Pledge> = Pledge.fetchRequest()
                    fetch.predicate = NSPredicate(format: "pledgeId == %@", id)
                    let result = try! managedContext.fetch(fetch)
                    
                    if result.count > 0 {
                        pledgeMO = result.first!
                    } else {
                        let pledgeEntity = NSEntityDescription.entity(forEntityName: EntityMap.Pledge.rawValue, in: managedContext)!
                        pledgeMO = Pledge(entity: pledgeEntity, insertInto: managedContext)
                    }
                    
                    setValuesPledgeMO(pledgeMO, pledges[i])
                    pledgeMO.contact = contactMO
                }
            }
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - File private functions for set values to MO
    // Contact
    fileprivate func setValuesContactMO(_ contactMO: Contact, _ contact: NSDictionary) {
        if let contactId = Int64(contact.value(forKey: ContactFields.contactId.rawValue) as! String) { contactMO.contactId = contactId }
        if let addressId = Int64(contact.value(forKey: ContactFields.addressId.rawValue)  as! String) { contactMO.addressId = addressId }
        if let emailId = Int64(contact.value(forKey: ContactFields.emailId.rawValue)  as! String) { contactMO.emailId = emailId }
        if let lastName = contact.value(forKey: ContactFields.lastName.rawValue) as? String { contactMO.lastName = lastName }
        if let firstName = contact.value(forKey: ContactFields.firstName.rawValue) as? String { contactMO.firstName = firstName }
        if let email = contact.value(forKey: ContactFields.email.rawValue) as? String { contactMO.email = email }        
        if let phone = contact.value(forKey: ContactFields.phone.rawValue) as? String { contactMO.phone = phone }
        if let phoneId = Int64(contact.value(forKey: ContactFields.phoneId.rawValue)  as! String) { contactMO.phoneId = phoneId }
        if let country = contact.value(forKey: ContactFields.country.rawValue) as? String { contactMO.country = country }
        if let contactType = contact.value(forKey: ContactFields.contactType.rawValue) as? String { contactMO.contactType = contactType }
        if let streetAddress = contact.value(forKey: ContactFields.streetAddress.rawValue) as? String { contactMO.streetAddress = streetAddress }
        if let city = contact.value(forKey: ContactFields.city.rawValue) as? String { contactMO.city = city }
        if let birthDateString = contact.value(forKey: ContactFields.birthDate.rawValue) as? String,
            let birthDate = dateFormatter.date(from: birthDateString) {
            contactMO.birthDate = birthDate as NSDate
        }
    }
    
    // Contribution
    fileprivate func setValuesContributionMO(_ contributionMO: Contribution, _ contribution: NSDictionary) {
        if let contactId = Int64(contribution.value(forKey: ContributionFields.contactId.rawValue)  as! String) { contributionMO.contactId = contactId }
        if let contributionId = Int64(contribution.value(forKey: ContributionFields.contributionId.rawValue)  as! String) { contributionMO.contributionId = contributionId }
        if let source = contribution.value(forKey: ContributionFields.source.rawValue) as? String { contributionMO.source = source }
        if let status = contribution.value(forKey: ContributionFields.status.rawValue) as? String { contributionMO.status = status }
        if let currency = contribution.value(forKey: ContributionFields.currency.rawValue) as? String { contributionMO.currency = currency }
        if let totalAmount = Double(contribution.value(forKey: ContributionFields.totalAmount.rawValue) as! String) { contributionMO.totalAmount = totalAmount }
        if let paymentInstrument = contribution.value(forKey: ContributionFields.paymentInstrument.rawValue) as? String { contributionMO.paymentInstrument = paymentInstrument }
        if let receiveDateStr = contribution.value(forKey: ContributionFields.receiveDate.rawValue) as? String,
            let receiveDate = dateFormatter.date(from: receiveDateStr) as NSDate?{
            contributionMO.receiveDate = receiveDate
        }
    }
    
    // Participant
    fileprivate func setValuesParticipantMO(_ participantMO: Participant, _ participant: NSDictionary) {
        if let contactId = Int64(participant.value(forKey: ParticipantFields.contactId.rawValue)  as! String) { participantMO.contactId = contactId }
        if let participantId = Int64(participant.value(forKey: ParticipantFields.participantId.rawValue)  as! String) { participantMO.participantId = participantId }
        if let eventId = Int64(participant.value(forKey: ParticipantFields.eventId.rawValue)  as! String) { participantMO.eventId = eventId }
        if let eventTitle = participant.value(forKey: ParticipantFields.eventTitle.rawValue) as? String { participantMO.eventTitle = eventTitle }
        if let eventType = participant.value(forKey: ParticipantFields.eventType.rawValue) as? String { participantMO.eventType = eventType }
        if let source = participant.value(forKey: ParticipantFields.source.rawValue) as? String { participantMO.source = source }
        if let status = participant.value(forKey: ParticipantFields.status.rawValue) as? String { participantMO.status = status }
        if let role = participant.value(forKey: ParticipantFields.role.rawValue) as? String { participantMO.role = role }
        if let feeCurrency = participant.value(forKey: ParticipantFields.feeCurrency.rawValue) as? String { participantMO.feeCurrency = feeCurrency }
        if let feeLevel = participant.value(forKey: ParticipantFields.feeLevel.rawValue) as? String { participantMO.feeLevel = feeLevel }
        if let feeAmount = Double(participant.value(forKey: ParticipantFields.feeAmount.rawValue) as! String) { participantMO.feeAmount = feeAmount }
        if let registerDateStr = participant.value(forKey: ParticipantFields.registerDate.rawValue) as? String,
            let registerDate = dateFormatter.date(from: registerDateStr) {
            participantMO.registerDate = registerDate as NSDate
        }
        if let eventEndDateStr = participant.value(forKey: ParticipantFields.eventEndDate.rawValue) as? String,
            let eventEndDate = dateFormatter.date(from: eventEndDateStr) {
            participantMO.eventEndDate = eventEndDate as NSDate
        }
        if let eventStartDateStr = participant.value(forKey: ParticipantFields.eventStartDate.rawValue) as? String,
            let eventStartDate = dateFormatter.date(from: eventStartDateStr) {
            participantMO.eventStartDate = eventStartDate as NSDate
        }
    }
    
    // Pledge
    fileprivate func setValuesPledgeMO(_ pledgeMO: Pledge, _ pledge: NSDictionary) {
        if let contactId = Int64(pledge.value(forKey: PledgeFields.contactId.rawValue) as! String) { pledgeMO.contactId = contactId }
        if let pledgeId = Int64(pledge.value(forKey: PledgeFields.pledgeId.rawValue)  as! String) { pledgeMO.pledgeId = pledgeId }
        if let frequencyInterval = Int16(pledge.value(forKey: PledgeFields.frequencyInterval.rawValue)  as! String) { pledgeMO.frequencyInterval = frequencyInterval }
        if let totalAmount = Double(pledge.value(forKey: PledgeFields .totalAmount.rawValue) as! String){ pledgeMO.totalAmount = totalAmount }
        if let totalPaid = Double(pledge.value(forKey: PledgeFields.totalPaid.rawValue) as! String) { pledgeMO.totalPaid = totalPaid }
        if let currency = pledge.value(forKey: PledgeFields.currency.rawValue) as? String { pledgeMO.currency = currency }
        if let financialType = pledge.value(forKey: PledgeFields.financialType.rawValue) as? String { pledgeMO.financialType = financialType }
        if let frequencyUnit = pledge.value(forKey: PledgeFields.frequencyUnit.rawValue) as? String { pledgeMO.frequencyUnit = frequencyUnit }
        if let status = pledge.value(forKey: PledgeFields.status.rawValue) as? String { pledgeMO.status = status }
        if let nextPayAmount = Double(pledge.value(forKey: PledgeFields.nextPayAmount.rawValue) as! String) { pledgeMO.nextPayAmount = nextPayAmount }
        if let startDateStr = pledge.value(forKey: PledgeFields.startDate.rawValue) as? String,
            let startDate = dateFormatter.date(from: startDateStr) {
            pledgeMO.startDate = startDate as NSDate
        }
        if let nextPayDateStr = pledge.value(forKey: PledgeFields.nextPayDate.rawValue) as? String,
            let nextPayDate = dateFormatter.date(from: nextPayDateStr) {
            pledgeMO.nextPayDate = nextPayDate as NSDate
        }
    }

}
