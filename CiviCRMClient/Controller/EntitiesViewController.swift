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
//    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var dataTask:  URLSessionTask?
    var entitiesArray: Array<[NSManagedObject]>?
    var contacts: [Contact]!
    var currentContact: Contact? {
        didSet {
            self.entitiesArray = currentContact?.sortedRelationsArray()
            self.title = currentContact!.firstName
            self.tableView?.reloadData()
        }
    }
    lazy var coreDataAdapter: CoreDataAdapter = {
        let adapter = CoreDataAdapter(context: managedContext)
        return adapter
    }()
    var errorMessage: String? {
        didSet {
            indicator.stopAnimating()
            tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            let alert = UIAlertController(title: "iCivi", message: self.errorMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            dataTask?.cancel()
        }
    }

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        indicator.hidesWhenStopped = true
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            propertiesViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PropertiesViewController
            propertiesViewController?.entityMO = entitiesArray![0][0] as? CiviCRMEntityDisplayed
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
        dataTask?.cancel()
        indicator.startAnimating()
        
        guard let request = RestAPIManager.shared.restAPIDefaultURLRequest() else { return }
        let session = URLSession.shared
        dataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            if error != nil {
                if error?.localizedDescription == "cancelled" { return }
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription
                }
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                
                do {
                    guard let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                        DispatchQueue.main.async {
                            self.errorMessage = UserMessage.internalError.rawValue
                        }
                        return
                    }
                    
                    if let isError = result.value(forKey: "is_error") as? Int, isError == 1,
                        let apiErrorMessage = result.value(forKey: "error_message") as? String {
                        DispatchQueue.main.async {
                            self.errorMessage = apiErrorMessage + UserMessage.referToAdmin.rawValue
                        }
                        return
                    } else if let count = result.value(forKey: "count") as? Int, count > 1 {
                        DispatchQueue.main.async {
                            self.errorMessage = UserMessage.extraPermissions.rawValue + UserMessage.referToAdmin.rawValue
                        }
                        return
                    } else if let id = result.value(forKey: "id") as? NSNumber {
                        self.coreDataAdapter.upsert(for: id, message: result)
                        DispatchQueue.main.async {
                            self.setCurrentContact()
                            self.indicator.stopAnimating()
                            self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = UserMessage.msgNotValid.rawValue + UserMessage.referToAdmin.rawValue
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
        if contacts.count > 0 {
            for c in contacts {
                if  (c.contactId > 1 && !demoMode) || (c.contactId == 1 && demoMode) {
                    currentContact = c
                    break
                } else {
                    currentContact = contacts.first
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension EntitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return entitiesArray!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let entity = entitiesArray![section][0] as? CiviCRMEntityDisplayed else {
            return nil
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
    
    // Delete the row from the local data base
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedContext.delete(entitiesArray![indexPath.section][indexPath.row])
            do {
                try managedContext.save()
            } catch {
                self.errorMessage = UserMessage.dbError.rawValue
                print(error.localizedDescription)
            }

            if entitiesArray![indexPath.section].count == 1 {
                entitiesArray!.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .fade)
            } else {
                entitiesArray![indexPath.section].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            setCurrentContact()
        }
    }
    
    // Prevent deletion of root contact
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let _ = entitiesArray![indexPath.section][indexPath.row] as? Contact else {
            return true
        }
        return false
    }
    
    // Start data load task by dragging down
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let loadingOffset: CGFloat = -100
        let demoMode: Bool = UserDefaults.standard.bool(forKey: "demo_mode_preference")
        
        if tableView.contentOffset.y < loadingOffset {
            if demoMode {
                coreDataAdapter.insertSampleData()
                setCurrentContact()
                tableView.reloadData()
            } else {
                tableView.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
                loadData()
            }
        }
    }
    
    // Cancell data load task by scroll up
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y > CGFloat(0), indicator.isAnimating {
            dataTask?.cancel()
            indicator.stopAnimating()
            tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        }
    }
}
