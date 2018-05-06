//
//  Contact+CoreDataClass.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 29/04/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    override public var description: String {
        let lastName = self.lastName ?? "(No Last Name)"
        let firstName = self.firstName ?? "(No First Name)"
        return "\(firstName) \(lastName)"
    }
    
}

