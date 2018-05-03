//
//  DataMap.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 01/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import Foundation

public enum DataMap: String {
    case Contact
    case Contribution
    case Pledge
    case Participant
    
    var asAPIChain: String {
        return "api." + self.rawValue + ".get"
    }
    
    var propertySet: String {
        return "values"
    }
    
    var displayLabel: String {
        switch self {
        case .Contact:
            return "Personal Details"
        case .Contribution:
            return "Payments"
        case .Pledge:
            return "Pledges"
        case .Participant:
            return "Events"
        }
    }
}

enum ContactMap: String {
    case lastName = "last_name"
    case firstName = "first_name"
    case contactId = "contact_id"
    case addressId = "address_id"
    case birthDate = "birth_date"
    case city = "city"
    case contactType = "contact_type"
    case country = "country"
    case email = "email"
    case emailId = "email_id"
    case phone = "phone"
    case phoneId = "phone_id"
    
}
