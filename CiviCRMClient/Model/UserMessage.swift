//
//  UserMessage.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 15/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import Foundation

enum UserMessage: String {
    case referToAdmin = " Please refer to CiviCRM administator."
    case msgNotValid = "Message not valid."
    case extraPermissions = "You have permissions to view other contacts."
    case internalError = "Internal error occures. Please retry later."
    case dbError = "Data base error occures. Please retry later."
}
