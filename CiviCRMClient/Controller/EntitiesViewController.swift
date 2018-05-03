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
    
    // MARK: - Class Properties
    
    lazy var coreDataAdapter: CoreDataAdapter = {
        let adapter = CoreDataAdapter(context: managedContext)
        return adapter
    }()
    
    var propertiesViewController: PropertiesViewController?
    
    var contacts: [Contact]!
    
    var currentContact: Contact?
    
    var managedContext: NSManagedObjectContext!
    
    var currContactDict: [String: Any]?
    
    private lazy var  entitiesArray = {() -> [NSOrderedSet] in
        var arr: Array = [NSOrderedSet]()
        
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
        coreDataAdapter.insertSampleData()
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        contacts = try! managedContext.fetch(fetch)
        currentContact = contacts.first
        title = currentContact?.firstName
        emailLabel.text = currentContact?.email
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            propertiesViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PropertiesViewController
            propertiesViewController?.entityMO = entitiesArray.first?.firstObject as? CiviCRMEntityDisplayed
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func showSettings(_ sender: UIBarButtonItem) {
        
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
    
}


// MARK: - UITableViewDataSource
extension EntitiesViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return entitiesArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = "(No Title)"
        let object = entitiesArray[section].firstObject
        
        if object is Contribution {
            sectionTitle = DataMap.Contribution.displayLabel
        } else if object is Participant {
            sectionTitle = DataMap.Participant.displayLabel
        } else if object is Pledge {
            sectionTitle = DataMap.Pledge.displayLabel
        }
        return sectionTitle
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



