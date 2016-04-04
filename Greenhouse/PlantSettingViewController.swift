//
//  PlantSettingViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 3/29/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit

class PlantSettingViewController: UIViewController {
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        let apiRequest = APIRequest(urlString: "http://\(Config.greenhouse)/api/plants/\(plant!.slotID!)")
        apiRequest.sendDeleteRequest()
        performSegueWithIdentifier("deletedPlantSegue", sender: self)
    }
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        // Update settings
    }
    var plant : ParsedPlant?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
