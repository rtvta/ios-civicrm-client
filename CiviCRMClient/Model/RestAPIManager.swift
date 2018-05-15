//
//  CiviCRMAPIManager.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 13/05/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import Foundation

final class RestAPIManager {
    static let shared = RestAPIManager()
    private init () {}
    
    let userDefaults = UserDefaults.standard
    
    struct ErrorMessage {
        static let referToAdmin = "Please refer to CiviCRM administator."
        static let msgNotValid = "Message not valid."
        static let extraPermissions = "You have permissions to view other contacts."
        static let internalError = "Internal error."
    }
    
    func restAPIDefaultURLRequest() -> URLRequest? {
        // Check application preference
        guard let baseURL = userDefaults.string(forKey: "civicrm_base_url"),
            let apiPath = userDefaults.string(forKey: "civicrm_api_path"),
            let apiKey = userDefaults.string(forKey: "civicrm_user_api_key"),
            let siteKey = userDefaults.string(forKey: "civicrm_site_key") else { return nil }
        
        // Create URL object
        guard let url = URL(string: baseURL + apiPath) else { return nil}
        
        // Set parameters
        let limit = 10
        let options = "\"options\":{\"limit\":\(limit),\"sort\":\"id DESC\"}"
        let params: [String: Any] = ["entity":"Contact",
                                     "action":"get",
                                     "api_key":apiKey,
                                     "key":siteKey,
                                     "json":EntityMap.Contact.relatedEntities]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var paramsString = ""
        for (key , val) in params {
            if key == "json" {
                if let chain = val as? [String] {
                    paramsString += "\(key)={"
                    for e in chain {
                        paramsString += "\"api.\(e).get\":{\(options)},"
                    }
                    paramsString.removeLast(1)
                    paramsString += "}&"
                } else {
                    paramsString += "1&"
                }
            } else {
                paramsString += "\(key)=\(val)&"
            }
        }
        paramsString.removeLast(1)
        
        print("RestAPIManager.urlString: " + url.absoluteString)
        print("RestAPIManager.paramString: " + paramsString)
        
        guard let body = paramsString.data(using: .utf8) else { return request}
        request.httpBody = body
        return request
    }
}
