//
//  MQTTManager.swift
//  Lights
//
//  Created by Daria on 07.04.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation
import Moscapsule

class MQTTManager {
    
    static let sharedInstance = MQTTManager()
    // Static variable...
    static private let brokerHost = "192.168.2.206"
    static private let port: Int32 = 1883, keepAlive: Int32 = 60
    static private let clientId = "cid"
    static private var mqttClient: MQTTClient!
    
    static let topic = "lights/"
    
    static func setMQTTClient() {
        let mqttConfig = MQTTConfig(clientId: clientId, host: brokerHost, port: port, keepAlive: keepAlive)
        mqttConfig.onMessageCallback = { mqttMessage in
            if mqttMessage.topic == "lights/all" {
                postToEveryone(mqttMessage.payloadString!)
                return
            }
            postNotification(topic: mqttMessage.topic, payload: mqttMessage.payloadString!)
        }
        mqttClient = MQTT.newConnection(mqttConfig)
    }
    
    static func postNotification(topic topic: String, payload: String) {
        NSNotificationCenter.defaultCenter().postNotificationName("reloadRow", object: sharedInstance, userInfo:
            ["ind": BulbManager.bulbs.indexOf({$0.topic == topic})!,
            "msg": payload == "on" ? true : false ])
    }
    
    static func postToEveryone(payload: String) {
        for bulb in BulbManager.bulbs {
            postNotification(topic: bulb.topic, payload: payload)
        }
    }
    
    static func publish(message msg: String, topic: String) {
        mqttClient.publishString(msg, topic: topic, qos: 0, retain: false)
    }
    
    static func subscribe(topic: String) {
        mqttClient.subscribe(topic, qos: 0)
    }
    
    static func unsubscribe(topic: String) {
        mqttClient.unsubscribe(topic)
    }
}