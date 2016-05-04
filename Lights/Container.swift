//
//  Container.swift
//  Lights
//
//  Created by Daria on 25/04/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class Container: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func lightsOff(sender: AnyObject) {
        MQTTManager.publish(message: "off", topic: "lights/all")
    }

    @IBAction func addLabel(sender: AnyObject) {
        let alert = UIAlertController(title: "Add new Label", message: "Bitte Daten eingeben", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Fertig", style: .Default, handler: { action in
            self.insertLabel(label: alert.textFields![0].text!, topic: alert.textFields![1].text!)
        }))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        alert.addTextFieldWithConfigurationHandler({ labelTF in self.modifyTextField(textField: labelTF, placeholder: "Label", text: "") })
        alert.addTextFieldWithConfigurationHandler({ topicTF in self.modifyTextField(textField: topicTF, placeholder: "Topic", text: "lights/") })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func modifyTextField(textField tf: UITextField, placeholder: String, text: String) {
        tf.placeholder = placeholder
        tf.text = text
    }
    
    func insertLabel(label lbl: String, topic: String) {
        BulbManager.createBulb(label: lbl, topic: topic, on: false)
        (self.childViewControllers.last as! UITableViewController).tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: BulbManager.bulbs.count - 1, inSection: 0)], withRowAnimation: .Automatic)
    }

}
