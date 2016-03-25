//
//  RootViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/10/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit

let defaultPlantURL : NSURL? = NSURL(string: "http://www.cymaorchids.com/img/us/22/big/Lilac-Phal-Orchid-500x500.png")
let defaultCondition : [String:Float]? = ["ideal": 15.0, "current": 11.3, "tolerance": 2.1]

class RootViewController: UITableViewController {

    let parsedPlants : [ParsedPlant] = [
        ParsedPlant(name: "Orchid", photoURL: defaultPlantURL, light: defaultCondition, water: defaultCondition, humidity: defaultCondition, temperature: defaultCondition, matureOn: NSDate(), slotID: 1, plantDatabaseID: 4)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadPlants()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadPlants() {
        tableView.reloadData()
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
        let matureDate = formatter.stringFromDate(parsedPlant.matureOn!)
        cell.plantMaturity?.text = matureDate
        if parsedPlant.photoURL != nil {
            if let imageData = NSData(contentsOfURL: parsedPlant.photoURL!) {
                cell.plantImage.image = UIImage(data: imageData)
            } else {
                print("cannot read url")
            }
        }
        return cell
    }
    
}

