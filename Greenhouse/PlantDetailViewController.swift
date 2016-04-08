//
//  PlantDetailViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/26/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit
import SwiftyJSON
import SocketIOClientSwift

class PlantDetailViewController: UIViewController, APIRequestDelegate {
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var currentLight: UILabel!
    @IBOutlet weak var currentWater: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var matureDate: UILabel!

    @IBOutlet weak var plantName: UINavigationItem!
    var plant : ParsedPlant?
    var socket : SocketIOClient?
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        socket?.disconnect()
        let apiRequest = APIRequest(urlString: "http://\(Config.greenhouse)/api/plants/\(plant!.slotID!)")
        apiRequest.sendDeleteRequest()
        performSegueWithIdentifier("deletedPlantSegue", sender: self)
    }
    
    func loadPlant() {
        displayBasicInfo()
        let apiRequest = APIRequest(urlString: "http://\(Config.greenhouse)/api/plants/\(plant!.slotID!)")
        apiRequest.sendGETRequest(self)
    }

    func handleData(data: NSData!) {
        if let dataValue = data {
            let plantData = JSON(data: dataValue)
            self.plant = ParsedPlant()
            self.plant?.name = plantData["name"].string!
            self.plant?.photoURL = NSURL(string: plantData["photo_url"].string!)
            self.plant?.slotID = plantData["slot_id"].int
            self.plant?.plantDatabaseID = plantData["id"].int

            // Load the conditions
            // Q: is there an easier way?
            self.plant?.light = [:]
            self.plant?.light!["current"] = plantData["light"].dictionary!["current"]!.float!
            self.plant?.light!["ideal"] = plantData["light"].dictionary!["ideal"]!.float!
            self.plant?.light!["tolerance"] = plantData["light"].dictionary!["tolerance"]!.float!
            self.plant?.humidity = [:]
            self.plant?.humidity!["current"] = plantData["humidity"].dictionary!["current"]!.float!
            self.plant?.humidity!["ideal"] = plantData["humidity"].dictionary!["ideal"]!.float!
            self.plant?.humidity!["tolerance"] = plantData["humidity"].dictionary!["tolerance"]!.float!
            self.plant?.temperature = [:]
            self.plant?.temperature!["current"] = plantData["temperature"].dictionary!["current"]!.float!
            self.plant?.temperature!["ideal"] = plantData["temperature"].dictionary!["ideal"]!.float!
            self.plant?.temperature!["tolerance"] = plantData["temperature"].dictionary!["tolerance"]!.float!
            self.plant?.water = [:]
            self.plant?.water!["current"] = plantData["water"].dictionary!["current"]!.float!
            self.plant?.water!["ideal"] = plantData["water"].dictionary!["ideal"]!.float!
            self.plant?.water!["tolerance"] = plantData["water"].dictionary!["tolerance"]!.float!
            let inputFormatter = NSDateFormatter()
            inputFormatter.dateFormat = "eee, d MMM yyyy HH:mm:ss z"
            self.plant?.matureOn = inputFormatter.dateFromString(plantData["mature_on"].string!)
            // Display the info
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.displayBasicInfo()
                self.displayFullInfo()
            })
        } else {
            print("handleData received no data")
        }
    }
    
    func displayFullInfo() {
        let light = self.plant!.light!["current"]!
        currentLight.text = "\(light) Lux"
        let water = self.plant!.water!["current"]!
        currentWater.text = String(water)
        let humidity = self.plant!.humidity!["current"]!
        currentHumidity.text = String(format: "%.1f%%", humidity)
        let temperature = self.plant!.temperature!["current"]!
        currentTemperature.text = String(format: "%.1f °F", temperature)
        let outputFormatter = NSDateFormatter()
        outputFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        matureDate.text = outputFormatter.stringFromDate((self.plant?.matureOn!)!)
    }
    
    func displayBasicInfo() {
        plantName.title = self.plant?.name
        if self.plant?.photoURL != nil {
            if let imageData = NSData(contentsOfURL: plant!.photoURL!) {
                plantImage.image = UIImage(data: imageData)
            } else {
                print("cannot read url")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlant()
        socket = SocketIOClient(socketURL: NSURL(string: "http://\(Config.greenhouse)")!, options: [.Nsp("/plants")])
        socket!.on("connect") {data, ack in
            print("Plant: socket connected")
        }
        socket!.on("data-update") {data, ack in
            self.loadPlant()
        }
        socket!.connect()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TODO: add segue that passes plant information to settings controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "plantSettingSegue" {
            if let navigationVC = segue.destinationViewController as? UINavigationController {
                if let plantSettingsVC = navigationVC.viewControllers.first as? PlantSettingViewController {
                    plantSettingsVC.plant = plant
                }
            }
        } else if segue.identifier == "plantChartSegue" {
            if let chartVC = segue.destinationViewController as? PlantChartViewController {
                chartVC.plantID = plant?.slotID
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
