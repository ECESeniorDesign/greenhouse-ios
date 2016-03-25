//
//  RootViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/10/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit
import SwiftyJSON

class RootViewController: UITableViewController, GreenhouseAPIRequestDelegate {

    var parsedPlants : [ParsedPlant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadPlants()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadPlants() {
        let apiRequest = GreenhouseAPIRequest(urlString: "http://localhost:5000/api/plants")
        apiRequest.sendRequest(self)
    }
 
    func handlePlantData(data: NSData!) {
        if let dataValue = data {
            let json = JSON(data: dataValue)
            if let plants = json["plants"].array {
                parsedPlants.removeAll(keepCapacity: true)
                for plant in plants {
                    let parsedPlant = ParsedPlant()
                    parsedPlant.name = plant["name"].string
                    parsedPlant.photoURL = NSURL(string: plant["photo_url"].string!)
                    self.parsedPlants.append(parsedPlant)
                }
            }
        } else {
            print("handlePlantData received no data")
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedPlants.count
    }
    
    override internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("plantCell") as! ParsedPlantCell
        let parsedPlant = parsedPlants[indexPath.row]
        cell.plantName?.text = parsedPlant.name
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        if parsedPlant.photoURL != nil {
            if let imageData = NSData(contentsOfURL: parsedPlant.photoURL!) {
                cell.plantImage.image = UIImage(data: imageData)
            } else {
                print("cannot read url")
            }
        }
        return cell
    }
    
    @IBAction func handleAddPlantButtonTapped(sender: AnyObject) {
        print("This feature is a WIP")
    }
}

