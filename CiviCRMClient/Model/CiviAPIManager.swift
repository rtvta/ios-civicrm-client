//
//  CiviCRMAPIManager.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 13/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import Foundation
import CoreData

typealias CiviAttributeDescription = (key: String, jsonKey: String, type: Int)
typealias CiviEntityDescription = (name: String, jsonKey: String, attributes: [CiviAttributeDescription])

enum UserMessage: String {
    case referToAdmin = " Please refer to CiviCRM administator."
    case msgNotValid = "Message not valid."
    case extraPermissions = "You have permissions to view other contacts."
    case internalError = "Internal error occures. Please retry later."
    case dbError = "Data base error occures. Please retry later."
}

enum Action: String {
    case get
    case create
}


final class CiviAPIManager {
    // MARK: - Singleton
    static let shared = CiviAPIManager()
    private init () {}

    // MARK: - Constants
    static let valuesKey: String = "values"
    
    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    lazy var coreDataStack = CoreDataStack(modelName: "CiviCRM Data")
    lazy var entitiesArray: [String] = ["Contact","Contribution","Participant","Pledge","Membership"]
    
    final lazy var civiEntitiesDescription: Array<CiviEntityDescription> = {
        var descriptions: Array<CiviEntityDescription> = [CiviEntityDescription]()
        for name in entitiesArray {
            let entity = NSEntityDescription.entity(forEntityName: name, in: coreDataStack.managedContext)!
            let userInfo = entity.userInfo as! [String:String]
            let jsonKey = userInfo["jsonKey"] ?? ""
            let attributes: Array<CiviAttributeDescription> = civiEntityAttributesDecription(entity: entity)
            let description: CiviEntityDescription = (name: name, jsonKey: jsonKey, attributes: attributes)
            descriptions.append(description)
        }
        return descriptions
    }()
    
    // MARK: - Functions
    func defaultURLRequest() -> URLRequest? {
        // Check application preference
        guard let baseURL = userDefaults.string(forKey: "civicrm_base_url"),
            let apiPath = userDefaults.string(forKey: "civicrm_api_path"),
            let apiKey = userDefaults.string(forKey: "civicrm_user_api_key"),
            let siteKey = userDefaults.string(forKey: "civicrm_site_key") else { return nil }
        
        // Create URL object
        guard let url = URL(string: baseURL + apiPath) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set parameters
        let limit = userDefaults.integer(forKey: "limit_rows_preference")
        let params: [String: Any] = ["entity": entitiesArray.first!,
                                     "action": Action.get,
                                     "api_key": apiKey,
                                     "key": siteKey]

        var paramsString = ""
        for (key , val) in params {
            paramsString += "\(key)=\(val)&"
        }
        paramsString += defaultJSONString(limit: limit)
        
        // print for test only
        print("RestAPIManager.urlString: " + url.absoluteString)
        print("RestAPIManager.paramString: " + paramsString)
        
        guard let body = paramsString.data(using: .utf8) else { return request}
        request.httpBody = body
        return request
    }
    
    // MARK: - Private functions
    fileprivate func defaultJSONString(limit: Int) -> String {
        var jsonString = ""
        let options = "\"options\":{\"limit\":\(limit),\"sort\":\"id DESC\"}"
        let returnKey = "\"return\":"
        let contactAttributesString = requestedAttributes(attributes: civiEntitiesDescription[0].attributes)
        
        jsonString += "json={"
        jsonString += "\(returnKey)\"\(contactAttributesString)\","
        for i in 1..<civiEntitiesDescription.count {
            let attributesString = requestedAttributes(attributes: civiEntitiesDescription[i].attributes)
            jsonString += "\"\(civiEntitiesDescription[i].jsonKey)\":{"
            jsonString += "\(returnKey)\"\(attributesString)\","
            jsonString += "\(options)"
            jsonString += "},"
        }
        jsonString.removeLast(1)
        jsonString += "}"

        return jsonString
    }
    
    fileprivate func civiEntityAttributesDecription(entity: NSEntityDescription) -> Array<CiviAttributeDescription> {
        var attributes = [CiviAttributeDescription]()
        for (key, val) in entity.attributesByName {
            let userInfo = val.userInfo as! [String:String]
            let jsonKey = userInfo["jsonKey"] ?? ""
            let attributeDescription: CiviAttributeDescription = (key: key, jsonKey: jsonKey, type: Int(val.attributeType.rawValue))
            attributes.append(attributeDescription)
        }
        
        return attributes
    }
    
    fileprivate func requestedAttributes(attributes: Array<CiviAttributeDescription>) -> String {
        var attributesString = ""
        for a in attributes where a.jsonKey != "id" {
            attributesString += "\(a.jsonKey),"
        }
        attributesString.removeLast(1)
        return attributesString
    }
}
