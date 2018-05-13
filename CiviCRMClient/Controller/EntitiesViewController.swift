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
    var managedContext: NSManagedObjectContext!
    
    lazy var coreDataAdapter: CoreDataAdapter = {
        let adapter = CoreDataAdapter(context: managedContext)
        return adapter
    }()
    
    var contacts: [Contact]!
    
    var currentContact: Contact? {
        didSet {
            self.entitiesArray = currentContact?.relationsArray()
            self.title = currentContact!.firstName
            self.tableView.reloadData()
        }
    }
    
    var entitiesArray: [NSOrderedSet]?
    
    let userDefaults = UserDefaults.standard
    
    var propertiesViewController: PropertiesViewController?

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCurrentContact()
        loadData()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            propertiesViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PropertiesViewController
            propertiesViewController?.entityMO = entitiesArray!.first?.firstObject as? CiviCRMEntityDisplayed
        }
        
        
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
                let entityMO = entitiesArray![indexPath.section][indexPath.row] as! CiviCRMEntityDisplayed
                let controller = (segue.destination as! UINavigationController).topViewController as! PropertiesViewController
                controller.entityMO = entityMO
            }
        }
    }
    
    // MARK: - Functions
    func loadData() {
        print("Start loading..." + NSDate().description)
        // Check application preference
        guard let baseURL = userDefaults.string(forKey: "civicrm_base_url"),
            let apiPath = userDefaults.string(forKey: "civicrm_api_path"),
            let apiKey = userDefaults.string(forKey: "civicrm_user_api_key"),
            let siteKey = userDefaults.string(forKey: "civicrm_site_key") else { return }
      
        guard let url = URL(string: baseURL + apiPath) else { return }
        
        // Set parameters
        let limit = 10
        let options = "\"options\":{\"limit\":\(limit),\"sort\":\"id DESC\"}"
        let params: [String: Any] = ["entity":"Contact",
                                    "action":"get",
                                    "api_key":apiKey,
                                    "key":siteKey,
                                    "json":EntityMap.Contact.relatedEntities]
      
        let request = urlRequest(url: url, params: params, options: options)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task: URLSessionTask = session.dataTask(with: request) { (data, response, error) -> Void in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            
            do {
                if let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print(result.description + NSDate().description)
                    self.coreDataAdapter.upsert(message: result)
                    DispatchQueue.main.async {
                        self.setCurrentContact()
                        print ("Finish loading..." + NSDate().description)
                    }
                }
            } catch let error as NSError{
                print(error)
            }
        }
        task.resume()
    }

    func urlRequest(url: URL, params: [String: Any], options: String) -> URLRequest {
        
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
    
    fileprivate func setCurrentContact() {
        let isDemoMode = userDefaults.bool(forKey: "demo_mode_preference")
        
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        contacts = try! managedContext.fetch(fetch)
        if contacts.count > 0 {
            for c in contacts {
                if  c.contactId > 1, !isDemoMode {
                    currentContact = c
                    print(c.contactId)
                    break
                } else if  c.contactId == 1, isDemoMode {
                    currentContact = c
                    print(c.contactId)
                    break
                } else {
                    currentContact = contacts.last
                    print(c.contactId)
                }
            }
        } else {
            coreDataAdapter.insertSampleData()
            contacts = try! managedContext.fetch(fetch)
            currentContact = contacts.first
        }
    }
}

// MARK: - UITableViewDataSource
extension EntitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return entitiesArray!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let entity = entitiesArray![section].firstObject as? CiviCRMEntityDisplayed else {
            return "(No Title)"
        }
        return entity.entityTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entitiesArray![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntityCell", for: indexPath)
        if let entity = entitiesArray![indexPath.section][indexPath.row] as? CiviCRMEntityDisplayed {
            cell.textLabel?.text = entity.entityLable
        }
        return cell
    }
}
