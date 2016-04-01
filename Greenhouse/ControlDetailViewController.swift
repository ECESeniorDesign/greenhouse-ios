//
//  ControlDetailViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 4/1/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit
import SwiftHTTP

class ControlDetailViewController: UIViewController {
    @IBAction func enabledSwitchChanged(sender: AnyObject) {
        activeSwitch.userInteractionEnabled = enabledSwitch.on
        restrictTimeSwitch.userInteractionEnabled = enabledSwitch.on
        if !enabledSwitch.on {
            activeSwitch.setOn(false, animated: true)
            restrictTimeSwitch.setOn(false, animated: true)
            startTimePicker.userInteractionEnabled = false
            endTimePicker.userInteractionEnabled = false
        }
    }
    @IBAction func restrictTimeSwitchChanged(sender: AnyObject) {
        startTimePicker.userInteractionEnabled = restrictTimeSwitch.on
        endTimePicker.userInteractionEnabled = restrictTimeSwitch.on
    }
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var restrictTimeSwitch: UISwitch!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!

    var whichControl : String?
    var control : ParsedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = control!.name
        enabledSwitch.setOn(control!.enabled, animated: true)
        activeSwitch.setOn(control!.active, animated: true)
        restrictTimeSwitch.setOn(control!.restrict_time, animated: true)
        startTimePicker.date = control!.active_start
        endTimePicker.date = control!.active_end
        startTimePicker.userInteractionEnabled = restrictTimeSwitch.on
        endTimePicker.userInteractionEnabled = restrictTimeSwitch.on
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Get info from the view
        control!.active = activeSwitch.on
        control!.enabled = enabledSwitch.on
        control!.restrict_time = restrictTimeSwitch.on
        control!.active_start = startTimePicker.date
        control!.active_end = endTimePicker.date
        // Pass info back to parent
        if isMovingFromParentViewController() {
            let navVC = self.parentViewController as! UINavigationController
            let parentVC = navVC.viewControllers[1] as! SettingsTableViewController
            parentVC.controls[whichControl!] = control!
            // Submit data to greenhouse
            let request = APIRequest(urlString: "http://\(Config.greenhouse)/api/settings/\(control!.id)")
            request.sendPOSTRequest(nil, params: control!.params())
        }
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
