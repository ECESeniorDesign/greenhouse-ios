//
//  NewPlantViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/25/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftHTTP

class NewPlantViewController: UITableViewController, APIRequestDelegate {

    var currentPlantIds : [String]?
    var slotId : Int?
    var parsedPlants : [ParsedPlant] = []
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let params : [String: AnyObject] = ["ids": ["4"]]
        do {
            let opt = try HTTP.POST("http://localhost:4000/api/plants/compatible", parameters: params, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                self.handlePlantData(response.data)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }

    }

    func handlePlantData(data: NSData!) {
        if let dataValue = data {
            let plants = JSON(data: dataValue).array
            parsedPlants.removeAll(keepCapacity: true)
            for plant in plants! {
                print(plant)
                let parsedPlant = ParsedPlant()
                parsedPlant.name = plant["name"].string
                parsedPlant.photoURL = NSURL(string: plant["photo_url"].string!)
                parsedPlant.plantDatabaseID = plant["id"].int!
                self.parsedPlants.append(parsedPlant)
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
        if parsedPlant.photoURL != nil {
            if let imageData = NSData(contentsOfURL: parsedPlant.photoURL!) {
                cell.plantImage.image = UIImage(data: imageData)
            } else {
                print("cannot read url")
            }
        }
        return cell
    }
    
    override internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let plant = parsedPlants[row]
        let params : [String: AnyObject] = ["plant_database_id": String(plant.plantDatabaseID!), "slot_id": String(self.slotId!)]
        print(params)
        do {
            let opt = try HTTP.POST("http://localhost:5000/api/plants", parameters: params)
            opt.start { response in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
