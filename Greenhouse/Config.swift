//
//  Config.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/30/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import Foundation

class Config : NSObject {
    static let defaultGreenhouse  = "10.32.0.101"
    static var greenhouse : String! {
        return "\(NSUserDefaults.standardUserDefaults().stringForKey("greenhouseIPAddress")!):5000"
    }
    static let plant_database = "10.32.0.101:4000"
}
