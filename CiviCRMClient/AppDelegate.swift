//
//  AppDelegate.swift
//  CiviCRMClient
//
//  Created by Roman Tiagni on 29/04/2018.
//  Copyright © 2018 Roman Tiagni. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    lazy var coreDataStack = CoreDataStack(modelName: "CiviCRM Data")
    var entitiesViewController: EntitiesViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let splitViewController = window?.rootViewController as? UISplitViewController,
            let navigationController = splitViewController.viewControllers[0] as? UINavigationController,
            let viewController = navigationController.topViewController as? EntitiesViewController else {
                return true
        }
        entitiesViewController = viewController
        let context = coreDataStack.managedContext
        
        entitiesViewController!.managedContext = context
        UserDefaults.standard.register(defaults: [String: Any]())
        
        let demoMode: Bool = UserDefaults.standard.bool(forKey: "demo_mode_preference")
        let coreDataAdapter = CoreDataAdapter(context: context)
        
        let fetch: NSFetchRequest<Contact> = Contact.fetchRequest()
        var contacts = try! context.fetch(fetch)
        if contacts.count > 0 {
            for c in contacts {
                if  (c.rowId > 1 && !demoMode) || (c.rowId == 1 && demoMode) {
                    viewController.currentContact = c
                    break
                } else {
                    viewController.currentContact = contacts.first
                }
            }
        } else {
            coreDataAdapter.insertSampleData()
            contacts = try! context.fetch(fetch)
            viewController.currentContact = contacts.first
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        entitiesViewController?.dataTask?.suspend()
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        entitiesViewController?.dataTask?.resume()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        entitiesViewController?.tableView?.reloadData()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        entitiesViewController?.dataTask?.cancel()
        coreDataStack.saveContext()
    }
    
}

