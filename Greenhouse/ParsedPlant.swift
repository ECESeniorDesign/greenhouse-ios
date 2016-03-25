//
//  ParsedPlant.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/25/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit

class ParsedPlant: NSObject {

    var name : String?
    var photoURL : NSURL?
    var light : [String:Float]?
    var water : [String:Float]?
    var humidity : [String:Float]?
    var temperature : [String:Float]?
    var matureOn : NSDate?
    var slotID : Int?
    var plantDatabaseID : Int?
    
    init(name: String?, photoURL: NSURL?, light: [String:Float]?, water: [String:Float]?,
         humidity: [String:Float]?, temperature: [String:Float]?, matureOn: NSDate?,
         slotID: Int?, plantDatabaseID: Int?)
    {
        super.init()
        self.name = name
        self.photoURL = photoURL
        self.light = light
        self.water = water
        self.humidity = humidity
        self.temperature = temperature
        self.matureOn = matureOn
        self.slotID = slotID
        self.plantDatabaseID = plantDatabaseID
    }

    override init() {
        super.init()
    }
    
}
