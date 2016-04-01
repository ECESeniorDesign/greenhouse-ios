//
//  ParsedControl.swift
//  Greenhouse
//
//  Created by Chase Conklin on 4/1/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit

class ParsedControl: NSObject {

    var id : Int
    var enabled : Bool
    var name : String
    var active : Bool
    var active_start : NSDate
    var active_end : NSDate
    var restrict_time : Bool

    init(id: Int, name: String, enabled: Bool, active: Bool, active_start: NSDate, active_end: NSDate, restrict_time: Bool) {
        self.id = id
        self.enabled = enabled
        self.name = name
        self.active = active
        self.active_start = active_start
        self.active_end = active_end
        self.restrict_time = restrict_time
    }

    func params() -> [String:AnyObject] {
        if restrict_time {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let start = formatter.stringFromDate(active_start)
            let end = formatter.stringFromDate(active_end)
            return ["enabled":enabled, "active":active, "active_start":start, "active_end":end]
        } else {
            return ["enabled":enabled, "active":active]
        }
    }
    
}
