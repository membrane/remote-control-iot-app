//
//  ConnectController.swift
//  Lights
//
//  Created by Daria on 15/06/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class ConnectController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeConnectLabel), name: "connectResult", object: MQTTManager.sharedInstance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func connectToBroker(sender: AnyObject) {
        MQTTManager.setMQTTClient()
    }
    
    func changeConnectLabel(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), {
            let connectResult = notification.userInfo?["result"] as! String
            print(connectResult)
            if connectResult == "Success" {
                // change label text
            } else {
                // display alert, smth is wrong
            }
        })
    }
    

}
