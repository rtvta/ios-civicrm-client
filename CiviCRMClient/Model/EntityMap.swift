//
//  EntityMap.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 06/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import Foundation

// MARK: - Entity header
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
            return "Personal Details"
        case .Contribution:
            return "My Payments"
        case .Pledge:
            return "My Pledges"
        case .Participant:
            return "My Events"
        }
    }
}

// MARK: - Contact fields
enum ContactFields: String {
    case lastName = "last_name"
    case firstName = "first_name"
    case contactId = "contact_id"
    case streetAddress = "street_address"
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

// MARK: - Contribution fields
enum ContributionFields: String {
    case contactId = "contact_id"
    case contributionId = "contribution_id"
    case currency = "currency"
    case paymentInstrument = "payment_instrument"
    case receiveDate = "receive_date"
    case source = "contribution_source"
    case status = "contribution_status"
    case totalAmount = "total_amount"
}

// MARK: - Participant fields
enum ParticipantFields: String {
    case contactId = "contact_id"
    case eventEndDate = "event_end_date"
    case eventStartDate = "event_start_date"
    case eventId = "event_id"
    case eventTitle = "event_title"
    case eventType = "event_type"
    case feeAmount = "participant_fee_amount"
    case feeCurrency = "participant_fee_currency"
    case feeLevel = "participant_fee_level"
    case participantId = "participant_id"
    case registerDate = "participant_register_date"
    case role = "participant_role"
    case source = "participant_source"
    case status = "participant_status"
}

// MARK: - Contact fields
enum PledgeFields: String {
    case contactId = "contact_id"
    case pledgeId = "pledge_id"
    case financialType = "pledge_financial_type"
    case frequencyUnit = "pledge_frequency_unit"
    case nextPayAmount = "pledge_next_pay_amount"
    case nextPayDate = "pledge_next_pay_date"
    case startDate = "pledge_start_date"
    case status = "pledge_status"
    case totalAmount = "pledge_amount"
    case totalPaid = "pledge_total_paid"
    case currency = "pledge_currency"
}
