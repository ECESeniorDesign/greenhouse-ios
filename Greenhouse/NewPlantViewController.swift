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
                let parsedPlant = ParsedPlant()
                parsedPlant.name = plant["name"].string
                parsedPlant.photoURL = NSURL(string: plant["photo_url"].string!)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
