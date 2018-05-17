//
//  EntityMap.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 06/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import Foundation

// MARK: - Entity headers
enum EntityMap: String {
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
    
    var entityTitle: String {
        switch self {
        case .Contact:
            return "Summary"
        case .Contribution:
            return "My Payments"
        case .Pledge:
            return "My Pledges"
        case .Participant:
            return "My Events"
        }
    }
    
    var relatedEntities: [String] {
        switch self {
        case .Contact:
            return ["Contribution","Participant","Pledge"]
        default:
            return [""]
        }
    }
}

// MARK: - Contact fields
enum ContactFields: String {
    case contactId = "id"
    case lastName = "last_name"
    case firstName = "first_name"
    case email = "email"
    case phone = "phone"
    case birthDate = "birth_date"
    case streetAddress = "street_address"
    case city = "city"
    case country = "country"
    case contactType = "contact_type"
    case addressId = "address_id"
    case emailId = "email_id"
    case phoneId = "phone_id"
}

// MARK: - Contribution fields
enum ContributionFields: String {
    case contributionId = "id"
    case source = "contribution_source"
    case status = "contribution_status"
    case totalAmount = "total_amount"
    case currency = "currency"
    case receiveDate = "receive_date"
    case paymentInstrument = "payment_instrument"
    case contactId = "contact_id"
}

// MARK: - Participant fields
enum ParticipantFields: String {
    case participantId = "id"
    case registerDate = "participant_register_date"
    case role = "participant_role"
    case source = "participant_source"
    case status = "participant_status"
    case eventEndDate = "event_end_date"
    case eventStartDate = "event_start_date"
    case eventTitle = "event_title"
    case eventType = "event_type"
    case feeAmount = "participant_fee_amount"
    case feeCurrency = "participant_fee_currency"
    case eventId = "event_id"
    case contactId = "contact_id"
}

// MARK: - Contact fields
enum PledgeFields: String {
    case pledgeId = "id"
    case totalAmount = "pledge_amount"
    case currency = "pledge_currency"
    case totalPaid = "pledge_total_paid"
    case status = "pledge_status"
    case financialType = "pledge_financial_type"
    case frequencyUnit = "pledge_frequency_unit"
    case startDate = "pledge_start_date"
    case nextPayAmount = "pledge_next_pay_amount"
    case nextPayDate = "pledge_next_pay_date"
    case frequencyInterval = "pledge_frequency_interval"
    case contactId = "contact_id"
}
