//
//  PlantSettingViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/29/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlantSettingViewController: UIViewController, APIRequestDelegate {
    @IBOutlet weak var thresholdsTable: UITableView!
    
    var notificationThresholds : [String: [NotificationThreshold]] = [:]
    var thresholdNames : [String] = []
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        // Update settings
    }
    var plant : ParsedPlant?

    func loadSettings() {
        let apiRequest = APIRequest(urlString: "http://\(Config.greenhouse)/api/plants/\(plant!.slotID!)/settings")
        apiRequest.sendGETRequest(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        loadSettings()
    }
    
    func handleData(data: NSData!) {
        if data != nil {
            thresholdNames = []
            notificationThresholds = [:]
            let json = JSON(data: data)
            let settings = json["settings"].array!
            for setting in settings {
                let notificationThreshold = NotificationThreshold(name: setting["sensor_name"].string!, id: setting["id"].int!, deviationTime: setting["deviation_time"].float!, deviationPercent: setting["deviation_percent"].float!)
                if notificationThresholds[notificationThreshold.name] != nil {
                    notificationThresholds[notificationThreshold.name]!.append(notificationThreshold)
                } else {
                    notificationThresholds[notificationThreshold.name] = [notificationThreshold]
                    thresholdNames.append(notificationThreshold.name)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.thresholdsTable.reloadData()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView( tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        return thresholdNames[section]
    }
    
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return thresholdNames.count
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationThresholds[thresholdNames[section]]!.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationThresholdCell")!
        let section = notificationThresholds[thresholdNames[indexPath.section]]!
        let threshold = section[indexPath.row]
        cell.textLabel?.text = "\(threshold.deviationPercent)% for \(threshold.deviationTime) hours"
        return cell
    }
    
    @IBAction func unwindToPlantSettingController (segue: UIStoryboardSegue?) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "newNTSegue" {
            let destinationVC = segue.destinationViewController as! NotificationSettingViewController
            destinationVC.threshold = NotificationThreshold(name: "water", id: 0, deviationTime: 0, deviationPercent: 0)
            destinationVC.action = "new"
            destinationVC.plantID = plant!.slotID
        } else if segue.identifier == "editNTSegue" {
            let destinationVC = segue.destinationViewController as! NotificationSettingViewController
            let indexPath = self.thresholdsTable!.indexPathForSelectedRow!
            let section = notificationThresholds[thresholdNames[indexPath.section]]!
            let threshold = section[indexPath.row]
            destinationVC.threshold = threshold
            destinationVC.action = "edit"
            destinationVC.plantID = plant!.slotID
        }
    }

}
