//
//  AlertController.swift
//  ImageUploader
//
//  Created by 1 on 17.02.19.
//  Copyright © 2019 Bogdan Magala. All rights reserved.
//

import UIKit

public class AlertController {
    weak public var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func showAlert() {
        let alertController = UIAlertController(title: "Failure!", message: "Failed to upload image.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func showConnectionAlert() {
        let alertController = UIAlertController(title: "Warning!", message: "Internet connection is required!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func showEraseAlert(tableView: UITableView) {
        let alertController = UIAlertController(title: "Warning!", message: "All links will be deleted!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            CoreDataMethods(viewController: self.viewController!).eraseAll()
            tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
