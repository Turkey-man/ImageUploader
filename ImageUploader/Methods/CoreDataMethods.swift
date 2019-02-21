//
//  CoreDataMethods.swift
//  ImageUploader
//
//  Created by 1 on 17.02.19.
//  Copyright © 2019 Bogdan Magala. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataMethods {
    weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

public func getContext() -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}

public func fetchLinks() {
    let context = getContext()
    let fetchRequest: NSFetchRequest<Link> = Link.fetchRequest()
    
    do {
        SingletonArrays.shared.links = try context.fetch(fetchRequest)
    } catch let error as NSError {
        let errorDialog = UIAlertController(title: "Error!", message: "Failed to fetch! \(error): \(error.userInfo)", preferredStyle: .alert)
        errorDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        viewController?.present(errorDialog, animated: true)
    }
}
    
public func saveLink(imageLink: String) {
    let context = getContext()
    let entity = NSEntityDescription.entity(forEntityName: "Link", in: context)
    let link = NSManagedObject(entity: entity!, insertInto: context) as! Link
    link.savedLink = imageLink
    
    do {
        try context.save()
        SingletonArrays.shared.links.append(link)
    } catch let error as NSError {
        let errorDialog = UIAlertController(title: "Error!", message: "Failed to save! \(error): \(error.userInfo)", preferredStyle: .alert)
        errorDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        viewController?.present(errorDialog, animated: true)
        }
    }
    
    public func deleteLink(tableView: UITableView, indexPath: IndexPath) {
        let context = getContext()
        context.delete(SingletonArrays.shared.links[indexPath.row])
        SingletonArrays.shared.links.remove(at: indexPath.row)
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .top)
        } catch let error as NSError {
            print("Failed to save. \(error), \(error.userInfo)")
        }
}

    public func eraseAll() {
        let context = getContext()
        for item in SingletonArrays.shared.links {
            context.delete(item)
            SingletonArrays.shared.links.removeAll()
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Failed to save. \(error), \(error.userInfo)")
        }
    }
    
}

