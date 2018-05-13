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
    
    var dataTask:  URLSessionTask?
    
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
        
        dataTask?.cancel()

        guard let request = NetworkManager.shared.defaultCiviCRMClientURLRequest() else { return }
        let session = URLSession.shared
        dataTask = session.dataTask(with: request) { (data, response, error) -> Void in
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
        dataTask?.resume()
    }

    fileprivate func setCurrentContact() {
        let demoMode = userDefaults.bool(forKey: "demo_mode_preference")
        
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        contacts = try! managedContext.fetch(fetch)
        if contacts.count > 0 {
            for c in contacts {
                if  c.contactId > 1, !demoMode {
                    currentContact = c
                    print(c.contactId)
                    break
                } else if  c.contactId == 1, demoMode {
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
