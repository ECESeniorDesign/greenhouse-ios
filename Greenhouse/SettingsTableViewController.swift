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
            var email : String
            var push : String
            var notify_plants : String
            var notify_maintenance : String
            if emailSwitch.on { email = "True" } else { email = "False" }
            if pushSwitch.on { push = "True" } else { push = "False" }
            if greenhouseMaintenanceSwitch.on { notify_maintenance = "True" } else { notify_maintenance = "False" }
            if plantConditionsSwitch.on { notify_plants = "True" } else { notify_plants = "False" }
            let params : [String:String] = ["email": email, "push": push, "notify_plants": notify_plants, "notify_maintenance":notify_maintenance]
            do {
                let opt = try HTTP.POST("http://\(Config.greenhouse)/api/notification_settings", parameters: params)
                opt.start { response in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
        }
        self.performSegueWithIdentifier("doneSegue", sender: self)
    }

    var loaded = false
    
    func handleData(data: NSData!) {
        if let dataValue = data {
            let notificationData = JSON(data: dataValue)
            if notificationData["email"].bool != nil {
                emailSwitch.setOn(notificationData["email"].bool!, animated: true)
                pushSwitch.setOn(notificationData["push"].bool!, animated: true)
                greenhouseMaintenanceSwitch.setOn(notificationData["notify_maintenance"].bool!, animated: true)
                plantConditionsSwitch.setOn(notificationData["notify_plants"].bool!, animated: true)
                self.loaded = true
            }
        } else {
            print("handleData received no data")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = APIRequest(urlString: "http://\(Config.greenhouse)/api/notification_settings")
        request.sendGETRequest(self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
