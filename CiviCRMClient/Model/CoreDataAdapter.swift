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
    
    // MARK: - Properties
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
        let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
        let sampleData = NSDictionary(contentsOfFile: path!)!
        let id = sampleData.value(forKey: "id") as! Int
        updateContext(for: id, message: sampleData)
    }
    
    // Upsert context from message
    func updateContext(for contactId: Int, message: NSDictionary) {
        let descriptions = CiviAPIManager.shared.civiEntitiesDescription
        let contactDescription = descriptions.first!
        
        var contactMO: Contact
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetch.predicate = NSPredicate(format: "rowId == %@", contactId as NSNumber)
        let result = try! managedContext.fetch(fetch)
        let contactEntity = NSEntityDescription.entity(forEntityName: contactDescription.name, in: managedContext)!
        if result.count > 0 {
            contactMO = result.first!
        } else {
            contactMO = Contact(entity: contactEntity, insertInto: managedContext)
        }

        guard let contactsDict = message[CiviAPIManager.valuesKey] as? NSDictionary,
                let contactDict = contactsDict.object(forKey: "\(contactId)") as? NSDictionary else { return }
        
        updateManagedObjectFromJSON(for: contactMO, with: contactDescription, from: contactDict)
        if contactMO.isInserted || !contactMO.changedValues().isEmpty {
            contactMO.notYetViewed = true
            contactMO.changeDate = NSDate()
        }
        
        for i in 1..<descriptions.count {
            let description = descriptions[i]
            guard let relationsDict = contactDict.value(forKey: description.jsonKey) as? NSDictionary,
                let relations = relationsDict[CiviAPIManager.valuesKey] as? [NSDictionary] else { continue }

            let entityDescription = NSEntityDescription.entity(forEntityName: description.name, in: managedContext)!
            
            for entityDict in relations {
                guard let id = Int(entityDict.value(forKey: "id") as! String) as NSNumber? else {
                    continue
                }

                switch description.name {
                case "Contribution":
                    let fetch: NSFetchRequest<Contribution> = Contribution.fetchRequest()
                    let  entityMO: Contribution
                    fetch.predicate = NSPredicate(format: "rowId == %@", id)
                    let result = try! managedContext.fetch(fetch)
                    if result.count > 0 {
                        entityMO = result.first!
                    } else {
                        entityMO = Contribution(entity: entityDescription, insertInto: managedContext)
                    }
                    updateManagedObjectFromJSON(for: entityMO, with: description, from: entityDict)
                    if entityMO.isInserted || !entityMO.changedValues().isEmpty {
                        entityMO.notYetViewed = true
                        entityMO.changeDate = NSDate()
                    }
                    entityMO.contact = contactMO
                    break
                case "Participant":
                    let fetch: NSFetchRequest<Participant> = Participant.fetchRequest()
                    var entityMO: Participant
                    fetch.predicate = NSPredicate(format: "rowId == %@", id)
                    let result = try! managedContext.fetch(fetch)
                    if result.count > 0 {
                        entityMO = result.first!
                    } else {
                        entityMO = Participant(entity: entityDescription, insertInto: managedContext)
                    }
                    updateManagedObjectFromJSON(for: entityMO, with: description, from: entityDict)
                    if entityMO.isInserted || !entityMO.changedValues().isEmpty {
                        entityMO.notYetViewed = true
                        entityMO.changeDate = NSDate()
                    }
                    entityMO.contact = contactMO
                    break
                case "Pledge":
                    let fetch: NSFetchRequest<Pledge> = Pledge.fetchRequest()
                    var entityMO: Pledge
                    fetch.predicate = NSPredicate(format: "rowId == %@", id)
                    let result = try! managedContext.fetch(fetch)
                    if result.count > 0 {
                        entityMO = result.first!
                    } else {
                        entityMO = Pledge(entity: entityDescription, insertInto: managedContext)
                    }
                    updateManagedObjectFromJSON(for: entityMO, with: description, from: entityDict)
                    if entityMO.isInserted || !entityMO.changedValues().isEmpty {
                        entityMO.notYetViewed = true
                        entityMO.changeDate = NSDate()
                    }
                    entityMO.contact = contactMO
                    break
                case "Membership":
                    let fetch: NSFetchRequest<Membership> = Membership.fetchRequest()
                    var entityMO: Membership
                    fetch.predicate = NSPredicate(format: "rowId == %@", id)
                    let result = try! managedContext.fetch(fetch)
                    if result.count > 0 {
                        entityMO = result.first!
                    } else {
                        entityMO = Membership(entity: entityDescription, insertInto: managedContext)
                    }
                    updateManagedObjectFromJSON(for: entityMO, with: description, from: entityDict)
                    if entityMO.isInserted || !entityMO.changedValues().isEmpty {
                        entityMO.notYetViewed = true
                        entityMO.changeDate = NSDate()
                    }
                    entityMO.contact = contactMO
                    break
                default:
                    continue
                }
            }
        }

        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Set values to managed object
    fileprivate func updateManagedObjectFromJSON(for mo: NSManagedObject, with descr: CiviEntityDescription, from message: NSDictionary) {
        for attribute in descr.attributes where !attribute.jsonKey.isEmpty{
            guard let jsonValue = message.value(forKey: attribute.jsonKey) as? String else { continue }
            
            switch attribute.type {
            case 300:
                guard let value = Int64(jsonValue) else { continue }
                mo.setValue(value, forKey: attribute.key)
                break
            case 500:
                guard let value = Double(jsonValue) else { continue }
                mo.setValue(value, forKey: attribute.key)
                break
            case 700:
                mo.setValue(jsonValue, forKey: attribute.key)
                break
            case 900:
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let value = dateFormatter.date(from: jsonValue as String) {
                    mo.setValue(value as NSDate, forKey: attribute.key)
                } else {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    guard let value = dateFormatter.date(from: jsonValue) as NSDate? else { continue }
                    mo.setValue(value as NSDate, forKey: attribute.key)
                }
                break
            default:
                break
            }
        }
    }
}
