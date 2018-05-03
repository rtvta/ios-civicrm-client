//
//  CiviCRMEntityDisplayed.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 03/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import Foundation

protocol CiviCRMEntityDisplayed {
    func getPropertiesForDisplayDictionary() -> [(String,String)]
    var entityLable: String { get }
}
