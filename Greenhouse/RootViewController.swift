//
//  RootViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/10/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit
import SwiftyJSON

let maxPlants = 2

class RootViewController: UITableViewController, APIRequestDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!

    var parsedPlants : [ParsedPlant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(RootViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func viewDidAppear(animated: Bool) {
        addButton.enabled = false
        reloadPlants()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadPlants() {
        let apiRequest = APIRequest(urlString: "http://\(Config.greenhouse)/api/plants")
        apiRequest.sendGETRequest(self)
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
                    parsedPlant.plantDatabaseID = plant["plant_database_id"].int
                    parsedPlant.slotID = plant["slot_id"].int
                    self.parsedPlants.append(parsedPlant)
                }
            }
        } else {
            print("handlePlantData received no data")
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.parsedPlants.count < maxPlants {
                self.addButton.enabled = true
            }
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPlantSegue" {
            let plantDatabaseIds = parsedPlants.map({ parsedPlant in
                String(parsedPlant.plantDatabaseID!)
            })
            let slotIds = parsedPlants.map({ parsedPlant in
                parsedPlant.slotID!
            })
            var slotId : Int? = nil
            for i in 1...maxPlants {
                if !slotIds.contains(i) {
                    slotId = i
                }
            }
            if let navigationVC = segue.destinationViewController as? UINavigationController {
                if let newPlantVC = navigationVC.viewControllers.first as? NewPlantViewController {
                    newPlantVC.currentPlantIds = plantDatabaseIds
                    newPlantVC.slotId = slotId
                }
            }
        } else if segue.identifier == "plantDetailSegue" {
            if let plantDetailVC = segue.destinationViewController as? PlantDetailViewController {
                let row = tableView!.indexPathForSelectedRow!.row
                let selectedPlant = parsedPlants[row] as ParsedPlant
                plantDetailVC.plant = selectedPlant
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "newPlantSegue" {
            return self.parsedPlants.count < maxPlants
        }
        return true
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        reloadPlants()
        addButton.enabled = false
        refreshControl.endRefreshing()
    }
    @IBAction func unwindToRootController (segue: UIStoryboardSegue?) {
    }

    
}

