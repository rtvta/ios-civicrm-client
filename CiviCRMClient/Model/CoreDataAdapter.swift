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
        
        testDataMap()
       
        let contactId = upsert(message: sampleData)
        
        print("Contact Id == \(contactId) has been inserted successfuly")
    }
    
    // Upsert
    func upsert(message: NSDictionary) -> Int {
        
        guard case let contactId as Int = message["id"] else {
            return 0
        }
        
        var contactMO: Contact
        var contact: NSDictionary
        var entityMap: DataMap = .Contact
        var contactsDict: NSDictionary
        
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetch.predicate = NSPredicate(format: "contactId == %@", contactId as NSNumber)
        let result = try! managedContext.fetch(fetch)
        
        if result.count > 0 {
            contactMO = result.first!
        } else {
            let contactEntity = NSEntityDescription.entity(forEntityName: entityMap.rawValue, in: managedContext)!
            contactMO = Contact(entity: contactEntity, insertInto: managedContext)
        }
        
        for (key, value) in message {
            if key as! String == entityMap.propertySet {
                contactsDict = value as! NSDictionary
                contact = contactsDict.object(forKey: "\(contactId)") as! NSDictionary
            } else {
                continue
            }
            
            contactMO.contactId = contact.value(forKey: "contact_id") as! Int32
            contactMO.addressId = contact.value(forKey: "address_id") as! Int32
            contactMO.lastName = contact.value(forKey: "last_name") as? String
            contactMO.firstName = contact.value(forKey: "first_name") as? String
            contactMO.email = contact.value(forKey: "email") as? String
            contactMO.emailId = contact.value(forKey: "email_id") as! Int32
            contactMO.phone = contact.value(forKey: "phone") as? String
            contactMO.phoneId = contact.value(forKey: "phone_id") as! Int32
            contactMO.country = contact.value(forKey: "country") as? String
            contactMO.contactType = contact.value(forKey: "contact_type") as? String
            contactMO.streetAddress = contact.value(forKey: "street_address") as? String
            contactMO.city = contact.value(forKey: "city") as? String
            if let birthDateString = contact.value(forKey: "birth_date") as? String, let birthDate = dateFormatter.date(from: birthDateString) {
                contactMO.birthDate = birthDate as NSDate
            }
            
            entityMap = .Contribution
            if let contributionsDict = contact.value(forKey: entityMap.asAPIChain) as? NSDictionary{
                for (key, value) in contributionsDict {
                    if key as! String == entityMap.propertySet, let contributions = value as? [NSDictionary] {
                        
                        var contributionMO: Contribution
                        var contributionId: Int
                        var contribution: NSDictionary
                        
                        for i in 0..<contributions.count {
                            contribution = contributions[i]
                            contributionId = contribution["id"] as! Int
                            
                            let fetch: NSFetchRequest<Contribution> = Contribution.fetchRequest()
                            fetch.predicate = NSPredicate(format: "contributionId == %@", contributionId as NSNumber)
                            let result = try! managedContext.fetch(fetch)
                            
                            if result.count > 0 {
                                contributionMO = result.first!
                            } else {
                                let contributionEntity = NSEntityDescription.entity(forEntityName: entityMap.rawValue, in: managedContext)!
                                contributionMO = Contribution(entity: contributionEntity, insertInto: managedContext)
                            }
                            
                            contributionMO.contactId = contribution.value(forKey: "contact_id") as! Int32
                            contributionMO.contributionId = contribution.value(forKey: "contribution_id") as! Int32
                            contributionMO.source = contribution.value(forKey: "contribution_source") as? String
                            contributionMO.status = contribution.value(forKey: "contribution_status") as? String
                            contributionMO.currency = contribution.value(forKey: "currency") as? String
                            contributionMO.totalAmount = contribution.value(forKey: "total_amount") as! Double
                            contributionMO.paymentInstrument = contribution.value(forKey: "payment_instrument") as? String
                            if let recieveDateStr = contribution.value(forKey: "receive_date") as? String, let recieveDate = dateFormatter.date(from: recieveDateStr) {
                                contributionMO.recieveDate = recieveDate as NSDate
                            }
                            contributionMO.contact = contactMO
                        }
                        
                    } else { continue }
                }
            }
            
            entityMap = .Participant
            if let participantDict = contact.value(forKey: entityMap.asAPIChain) as? NSDictionary{
                for (key, value) in participantDict {
                    if key as! String == entityMap.propertySet, let participants = value as? [NSDictionary] {
                        
                        var participantMO: Participant
                        var participantId: Int
                        var participant: NSDictionary
                        
                        for i in 0..<participants.count {
                            participant = participants[i]
                            participantId = participant["id"] as! Int
                            
                            let fetch: NSFetchRequest<Participant> = Participant.fetchRequest()
                            fetch.predicate = NSPredicate(format: "participantId == %@", participantId as NSNumber)
                            let result = try! managedContext.fetch(fetch)
                            
                            if result.count > 0 {
                                participantMO = result.first!
                            } else {
                                let participantEntity = NSEntityDescription.entity(forEntityName: entityMap.rawValue, in: managedContext)!
                                participantMO = Participant(entity: participantEntity, insertInto: managedContext)
                            }
                            
                            participantMO.contactId = participant.value(forKey: "contact_id") as! Int32
                            participantMO.participantId = participant.value(forKey: "participant_id") as! Int32
                            participantMO.eventId = participant.value(forKey: "event_id") as! Int32
                            participantMO.eventTitle = participant.value(forKey: "event_title") as? String
                            participantMO.eventType = participant.value(forKey: "event_type") as? String
                            participantMO.source = participant.value(forKey: "participant_source") as? String
                            participantMO.status = participant.value(forKey: "participant_status") as? String
                            participantMO.role = participant.value(forKey: "participant_role") as? String
                            participantMO.feeCurrency = participant.value(forKey: "participant_fee_currency") as? String
                            participantMO.feeLevel = participant.value(forKey: "participant_fee_level") as? String
                            participantMO.feeAmount = participant.value(forKey: "participant_fee_amount") as! Double
                            if let registerDateStr = participant.value(forKey: "register_date") as? String, let registerDate = dateFormatter.date(from: registerDateStr) {
                                participantMO.registerDate = registerDate as NSDate
                            }
                            if let eventEndDateStr = participant.value(forKey: "event_end_date") as? String, let eventEndDate = dateFormatter.date(from: eventEndDateStr) {
                                participantMO.eventEndDate = eventEndDate as NSDate
                            }
                            if let eventStartDateStr = participant.value(forKey: "event_start_date") as? String, let eventStartDate = dateFormatter.date(from: eventStartDateStr) {
                                participantMO.eventStartDate = eventStartDate as NSDate
                            }
                            participantMO.contact = contactMO
                        }
                        
                    } else { continue }
                }
            }
        
        }
        
        try! managedContext.save()
        
        return contactId
    }
    
    func deleteFirst() -> Bool {
//        let contactId = message["id"] as! Int
//        var contact: Contact!
        
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
//        fetch.predicate = NSPredicate(format: "contactId == %@", contactId as NSNumber)
        let result = try! managedContext.fetch(fetch)
        
        guard result.count > 0, let contact = result.first else {
             return false
        }
        managedContext.delete(contact)
        try! managedContext.save()

        return true
    }
    
    func delete(entity: DataMap, id: Int) -> Bool {
        return true
    }
    
    
    func testDataMap() {
        print("\(DataMap.Contact), \(DataMap.Contact.rawValue), \(DataMap.Contact.propertySet), \(DataMap.Contribution.asAPIChain)")
    }
    
    
    
}
