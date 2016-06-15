//
//  BulbManager.swift
//  Lights
//
//  Created by Daria on 07.04.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation

class BulbManager {
    
    static var bulbs = [Bulb]()
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static func loadDefaults() {
        if let decoded = defaults.objectForKey("bulbs") {
            bulbs = NSKeyedUnarchiver.unarchiveObjectWithData(decoded as! NSData) as! [Bulb]
        } else { initDefaults() }
    }
    
    static func initDefaults() {
        createBulb(label: "Kitchen", topic: MQTTManager.topic + "kitchen", on: false)
        createBulb(label: "Room \"To-the-Left\"", topic: MQTTManager.topic + "room-left", on: false)
    }
    
    static func saveDefaults() {
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(bulbs)
        defaults.setObject(encodedData, forKey: "bulbs")
    }
    
    static func createBulb(label lbl: String, topic: String, on: Bool) {
        bulbs.append(Bulb(label: lbl, topic: topic, on: on))
        saveDefaults()
    }
    
    static func deleteBulb(atIndex index: Int) {
        MQTTManager.unsubscribe(bulbs[index].topic)
        bulbs.removeAtIndex(index)
        saveDefaults()
    }
    
    static func changeBulbStatus(withIndex index: Int) {
        bulbs[index].on = !bulbs[index].on
        saveDefaults()
    }
    
    class Bulb: NSObject, NSCoding {
        let label: String
        let topic: String
        var on: Bool
        
        init(label lbl: String, topic: String, on: Bool) {
            self.label = lbl
            self.topic = topic
            self.on = on
        }
        
        required convenience init(coder aDecoder: NSCoder) {
            let label = aDecoder.decodeObjectForKey("label") as! String
            let topic = aDecoder.decodeObjectForKey("topic") as! String
            let on = aDecoder.decodeBoolForKey("on")
            self.init(label: label, topic: topic, on: on)
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(label, forKey: "label")
            aCoder.encodeObject(topic, forKey: "topic")
            aCoder.encodeBool(on, forKey: "on")
        }
    }
    
}