//
//  ViewController.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 29/04/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import UIKit
import CoreData

class EntitiesViewController: UIViewController {
    
    // MARK: - Properties
    lazy var coreDataAdapter: CoreDataAdapter = {
        let adapter = CoreDataAdapter(context: managedContext)
        return adapter
    }()
    
    var propertiesViewController: PropertiesViewController?
    
    var contacts: [Contact]!
    
    var currentContact: Contact?
    
    var managedContext: NSManagedObjectContext!
    
    var userDefaults: UserDefaults?
    
    private lazy var  entitiesArray = {() -> [NSOrderedSet] in
        var arr: Array = [NSOrderedSet]()
        var person = NSMutableOrderedSet()
        if let contact = self.currentContact {
            person[0] = contact
            arr.append(person)
        }
        if let contribution = self.currentContact?.contribution, contribution.count > 0 {
            arr.append(contribution)
        }
        if let participant = self.currentContact?.participant, participant.count > 0 {
            arr.append(participant)
        }
        if let pledge = self.currentContact?.pledge, pledge.count > 0 {
            arr.append(pledge)
        }
        return arr
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var personalDetailsView: UIView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isDemo = userDefaults?.bool(forKey: "demo_mode_preference") ?? false
        
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        contacts = try! managedContext.fetch(fetch)
        if contacts.count > 0 {
            currentContact = contacts.first
            
            for c in contacts {
                print(c.contactId)
                if  c.contactId > 1, !isDemo {
                    currentContact = c
                    print("Contact changed to \(c.contactId)")
                } else if  c.contactId == 1, isDemo {
                    currentContact = c
                    print("Contact changed to \(c.contactId)")
                }
            }
        } else {
            coreDataAdapter.insertSampleData()
            contacts = try! managedContext.fetch(fetch)
            currentContact = contacts.first
        }

        
        title = currentContact?.firstName
        emailLabel.text = currentContact?.email
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            propertiesViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PropertiesViewController
            propertiesViewController?.entityMO = entitiesArray.first?.firstObject as? CiviCRMEntityDisplayed
        }
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    @IBAction func showSettings(_ sender: UIBarButtonItem) {
        if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProperties" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let entityMO = entitiesArray[indexPath.section][indexPath.row] as! CiviCRMEntityDisplayed
                let controller = (segue.destination as! UINavigationController).topViewController as! PropertiesViewController
                controller.entityMO = entityMO
            }
        }
    }
    
    // MARK: - Functions
    func loadData() {
        print("Start loading..." + NSDate().description)
        
        // Check application preference
        guard let urlString = userDefaults?.string(forKey: "url_preference"),
            let apiKey = userDefaults?.string(forKey: "api_key_preference"),
            let siteKey = userDefaults?.string(forKey: "site_key_preference") else { return }
        
        guard let url = URL(string: urlString) else { return }
        
        // Set parameters
        let limit = 10
        let options = "\"options\":{\"limit\":\(limit),\"sort\":\"id DESC\"}"
        let params: [String: Any] = ["entity":"Contact",
                                    "action":"get",
                                    "api_key":apiKey,
                                    "key":siteKey,
                                    "json":EntityMap.Contact.relatedEntities]
      
        let request = clientUrlRequest(url: url, params: params, options: options)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task: URLSessionTask = session.dataTask(with: request) { (data, response, error) -> Void in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            
            do {
                if let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    self.coreDataAdapter.upsert(message: result)
                    print(result.description)
                }
            } catch let error as NSError{
                print(error)
            }
        }
        task.resume()
    }

    func clientUrlRequest(url: URL, params: [String: Any], options: String) -> URLRequest {
        
        print("Client URL: \(url.absoluteString)")
        
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
        
        print("Params: " + paramsString)

        guard let body = paramsString.data(using: .utf8) else { return request}
        request.httpBody = body
        return request
    }
}

// MARK: - UITableViewDataSource
extension EntitiesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return entitiesArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let entity = entitiesArray[section].firstObject as? CiviCRMEntityDisplayed else {
            return "(No Title)"
        }
        return entity.entityTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entitiesArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntityCell", for: indexPath)
        if let entity = entitiesArray[indexPath.section][indexPath.row] as? CiviCRMEntityDisplayed {
            cell.textLabel?.text = entity.entityLable
        }
        return cell
    }
}
