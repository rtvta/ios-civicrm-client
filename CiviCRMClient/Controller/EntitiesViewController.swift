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
    var propertiesViewController: PropertiesViewController?
    var dataTask:  URLSessionTask?
    var entitiesArray: [NSOrderedSet]?
    var contacts: [Contact]!
    var currentContact: Contact? {
        didSet {
            self.entitiesArray = currentContact?.relationsArray()
            self.title = currentContact!.firstName
            self.tableView.reloadData()
        }
    }
    lazy var coreDataAdapter: CoreDataAdapter = {
        let adapter = CoreDataAdapter(context: managedContext)
        return adapter
    }()
    var errorMessage: String? {
        didSet {
            print("\(self.errorMessage!)")
            let alert = UIAlertController(title: "API Error", message: self.errorMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCurrentContact()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            propertiesViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PropertiesViewController
            propertiesViewController?.entityMO = entitiesArray!.first?.firstObject as? CiviCRMEntityDisplayed
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
        guard let request = RestAPIManager.shared.restAPIDefaultURLRequest() else { return }
        let session = URLSession.shared
        dataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription
                }
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                
                do {
                    guard let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                        DispatchQueue.main.async {
                            self.errorMessage = RestAPIManager.ErrorMessage.internalError
                        }
                        return
                    }
                    
                    if let isError = result.value(forKey: "is_error") as? Int, isError == 1,
                        let apiErrorMessage = result.value(forKey: "error_message") as? String {
                        DispatchQueue.main.async {
                            self.errorMessage = apiErrorMessage + RestAPIManager.ErrorMessage.referToAdmin
                        }
                        return
                    } else if let count = result.value(forKey: "count") as? Int, count > 1 {
                        DispatchQueue.main.async {
                            self.errorMessage = RestAPIManager.ErrorMessage.extraPermissions + RestAPIManager.ErrorMessage.referToAdmin
                        }
                        return
                    } else if let id = result.value(forKey: "id") as? NSNumber {
                        self.coreDataAdapter.upsert(for: id, message: result)
                        DispatchQueue.main.async {
                            self.setCurrentContact()
                            print("Success!")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = RestAPIManager.ErrorMessage.msgNotValid + RestAPIManager.ErrorMessage.referToAdmin
                        }
                    }
                    
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                }
                
            } else {
                self.errorMessage = response!.description
            }
        }
        dataTask?.resume()
    }

    fileprivate func setCurrentContact() {
        let demoMode: Bool = UserDefaults.standard.bool(forKey: "demo_mode_preference")
        
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        contacts = try! managedContext.fetch(fetch)
        print("Contact count: \(contacts.count)")
        if contacts.count > 0 {
            for c in contacts {
                if  (c.contactId > 1 && !demoMode) || (c.contactId == 1 && demoMode) {
                    currentContact = c
                    break
                } else {
                    currentContact = contacts.first
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
