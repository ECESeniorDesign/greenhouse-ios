//
//  NotificationThreshold.swift
//  Greenhouse
//
//  Created by Chase Conklin on 4/4/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import Foundation

class NotificationThreshold : NSObject {

    var name : String
    var id : Int
    var deviationTime : Float
    var deviationPercent : Float
    
    init(name: String, id: Int, deviationTime: Float, deviationPercent: Float) {
        self.name = name
        self.id = id
        self.deviationTime = deviationTime
        self.deviationPercent = deviationPercent
    }
    
}
