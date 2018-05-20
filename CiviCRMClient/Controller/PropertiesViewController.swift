//
//  PropertiesViewController.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 29/04/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import UIKit
import CoreData

class PropertiesViewController: UIViewController {
    
    // MARK: - Properties    
    var propertiesDict: [(String, String)]?

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Configure view
    var entityMO: CiviEntityDisplayed? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        propertiesDict = entityMO?.propertiesForDisplay()
        self.title = entityMO?.entityLabel
    }

}

// MARK: - UITableViewDataSource
extension PropertiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = propertiesDict else {
            return 1
        }
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertiesCell", for: indexPath)
        cell.textLabel?.text = propertiesDict?[indexPath.row].0
        cell.detailTextLabel?.text = propertiesDict?[indexPath.row].1
        return cell
    }
    
}
