//
//  BulbController.swift
//  Lights
//
//  Created by Daria on 07.04.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class BulbController: UITableViewController {
    
    let cellIdentifier = "bulbCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        BulbManager.loadDefaults()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadRow), name: "reloadRow", object: MQTTManager.sharedInstance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadRow(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) {
            let bulbInd = notification.userInfo?["ind"] as! Int
            if BulbManager.bulbs[bulbInd].on != notification.userInfo?["msg"] as! Bool {
                BulbManager.changeBulbStatus(withIndex: bulbInd)
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: bulbInd, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BulbManager.bulbs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BulbCell
        cell.label.text = BulbManager.bulbs[indexPath.row].label
        cell.pic.image = BulbManager.bulbs[indexPath.row].on ? UIImage(named: "on") : UIImage(named: "off")
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        BulbManager.changeBulbStatus(withIndex: indexPath.row)
        let command = BulbManager.bulbs[indexPath.row].on ? "on" : "off"
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! BulbCell
        cell.pic.image = BulbManager.bulbs[indexPath.row].on ? UIImage(named: "on") : UIImage(named: "off")
        MQTTManager.publish(message: command, topic: BulbManager.bulbs[indexPath.row].topic)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            BulbManager.deleteBulb(atIndex: indexPath.row)
            tableView.reloadData()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadRow", object: MQTTManager.self)
    }

}
