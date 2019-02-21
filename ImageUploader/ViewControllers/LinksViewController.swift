//
//  LinksViewController.swift
//  ImageUploader
//
//  Created by 1 on 14.02.19.
//  Copyright © 2019 Bogdan Magala. All rights reserved.
//

import UIKit

public class LinksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataMethods(viewController: self).fetchLinks()
        self.tableView.reloadData()
    }
    public func addEraseButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Erase all",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector (eraseAll))
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    //MARK:-- Deleting all links
    @objc public func eraseAll() {
        if SingletonArrays.shared.links.count != 0 {
        AlertController(viewController: self).showEraseAlert(tableView: self.tableView)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.title = "Links"
        self.addEraseButton()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SingletonArrays.shared.links.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let link = SingletonArrays.shared.links[indexPath.row]
        cell.textLabel?.text = link.savedLink
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = SingletonArrays.shared.links[indexPath.row].savedLink
        if let url = URL(string: urlString!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataMethods(viewController: self).deleteLink(tableView: self.tableView, indexPath: indexPath)
        }
    }
}
