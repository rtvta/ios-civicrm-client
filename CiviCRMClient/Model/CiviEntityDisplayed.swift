//
//  CiviCRMEntityDisplayed.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 03/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import Foundation

protocol CiviEntityDisplayed {
    func propertiesForDisplay() -> [(String,String)]
    var alreadyViewed: Bool { get set }
    var entityLabel: String { get }
    var entityTitle: String { get }
}
