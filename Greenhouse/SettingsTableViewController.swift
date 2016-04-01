//
//  SettingsTableViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/31/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftHTTP

class SettingsTableViewController: UITableViewController, APIRequestDelegate {
    @IBOutlet weak var greenhouseMaintenanceSwitch: UISwitch!
    @IBOutlet weak var plantConditionsSwitch: UISwitch!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var pushSwitch: UISwitch!
    @IBAction func doneButtonPressed(sender: AnyObject) {
        if loaded {
            let params : [String:AnyObject] = ["email": emailSwitch.on, "push": pushSwitch.on, "notify_plants": plantConditionsSwitch.on, "notify_maintenance": greenhouseMaintenanceSwitch.on]
            let apiRequest = APIRequest(urlString: "http://\(Config.greenhouse)/api/notification_settings")
            apiRequest.sendPOSTRequest(nil, params: params)
        }
        self.performSegueWithIdentifier("doneSegue", sender: self)
    }

    var loaded = false
    var controls : [String:ParsedControl] = [:]
    
    func handleData(data: NSData!) {
        if let dataValue = data {
            let notificationData = JSON(data: dataValue)
            if notificationData["email"].bool != nil {
                emailSwitch.setOn(notificationData["email"].bool!, animated: true)
                pushSwitch.setOn(notificationData["push"].bool!, animated: true)
                greenhouseMaintenanceSwitch.setOn(notificationData["notify_maintenance"].bool!, animated: true)
                plantConditionsSwitch.setOn(notificationData["notify_plants"].bool!, animated: true)
                self.loaded = true
            } else if notificationData["fan"]["id"] != nil {
                for (control, controlJSON) : (String, JSON) in notificationData {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss"
                    var startDate : NSDate
                    var endDate : NSDate
                    var restrictTime : Bool
                    if controlJSON["active_start"].string != nil {
                        startDate = dateFormatter.dateFromString(controlJSON["active_start"].string!)!
                        endDate = dateFormatter.dateFromString(controlJSON["active_end"].string!)!
                        restrictTime = true
                    } else {
                        startDate = dateFormatter.dateFromString("00:00:00")!
                        endDate = dateFormatter.dateFromString("00:00:00")!
                        restrictTime = false
                    }
                    var controlName : String
                    switch control {
                        case "pump": controlName = "Mist Pump"
                        case "fan": controlName = "Fans"
                        case "light": controlName = "Lights"
                    default: controlName = "Control"
                    }
                    let parsedControl = ParsedControl(id: controlJSON["id"].int!, name: controlName, enabled: controlJSON["enabled"].bool!, active: controlJSON["active"].bool!, active_start: startDate, active_end: endDate, restrict_time: restrictTime)
                    controls[control] = parsedControl
                }
            }
        } else {
            print("handleData received no data")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = APIRequest(urlString: "http://\(Config.greenhouse)/api/notification_settings")
        request.sendGETRequest(self)
        let controlRequest = APIRequest(urlString: "http://\(Config.greenhouse)/api/settings")
        controlRequest.sendGETRequest(self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationVC = segue.destinationViewController as? ControlDetailViewController {
            switch segue.identifier! {
            case "mistPumpDetailSegue":
                destinationVC.control = controls["pump"]
                destinationVC.whichControl = "pump"
            case "lightsDetailSegue":
                destinationVC.control = controls["light"]
                destinationVC.whichControl = "light"
            case "fansDetailSegue":
                destinationVC.control = controls["fan"]
                destinationVC.whichControl = "fan"
            default:
                // Shouldn't happen
                print("Shouldn't see this")
                destinationVC.control = nil
                destinationVC.whichControl = nil
            }
        }
    }

}
