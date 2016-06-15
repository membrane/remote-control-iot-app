//
//  ConnectController.swift
//  Lights
//
//  Created by Daria on 15/06/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class ConnectController: UIViewController {
    
    @IBOutlet weak var host: UITextField!
    @IBOutlet weak var port: UITextField!
    @IBOutlet weak var statusMsg: UILabel!
    @IBOutlet weak var connectBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeConnectLabel), name: "connectResult", object: MQTTManager.sharedInstance)
    }
    /*
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        host.resignFirstResponder()
        port.resignFirstResponder()
        return true
    }
    */
    
    @IBAction func connectToBroker(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            MQTTManager.setMQTTClient(brokerHost: self.host.text!, port: Int32(self.port.text!)!)
        }
    }
    
    func changeConnectLabel(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissKeyboard()
            
            let connectResult = notification.userInfo?["result"] as! String
            if connectResult == "Success" {
                MQTTManager.subscribe(MQTTManager.topic + "#")
                self.connectBtn.setTitle("Disconnect", forState: .Normal)
                self.statusMsg.text = "Connected"
            }
            else if connectResult == "Disconnect_Requested" {
                MQTTManager.unsubscribe(MQTTManager.topic + "#")
                MQTTManager.disconnect()
                self.connectBtn.setTitle("Connect", forState: .Normal)
                self.statusMsg.text = "Disconnected"
            }
            else {
                self.presentResultAlert(connectResult)
            }
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentResultAlert(result: String) {
        let alert = UIAlertController(title: "Connection Result", message: result, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "connectResult", object: MQTTManager.self)
    }

}
