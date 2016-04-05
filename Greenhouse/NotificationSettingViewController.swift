//
//  NotificationSettingViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 4/4/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit

class NotificationSettingViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        let apiRequest = APIRequest(urlString: "http://\(Config.greenhouse)/api/plants/\(plantID!)/settings/\(threshold!.id)")
        apiRequest.sendDeleteRequest()
        self.performSegueWithIdentifier("exitNTSegue", sender: self)
    }
    @IBAction func doneButtonPressed(sender: AnyObject) {
        let sensorName = sensors[sensorNamePicker.selectedRowInComponent(0)].lowercaseString
        let params : [String : AnyObject] = ["sensor_name": sensorName, "deviation_time": timeStepper.value, "deviation_percent": percentStepper.value]
        var urlString : String
        if action == "edit" {
            urlString = "http://\(Config.greenhouse)/api/plants/\(plantID!)/settings/\(threshold!.id)"
        } else {
            urlString = "http://\(Config.greenhouse)/api/plants/\(plantID!)/settings"
        }
        
        let apiRequest = APIRequest(urlString: urlString)
        apiRequest.sendPOSTRequest(nil, params: params)

        self.performSegueWithIdentifier("exitNTSegue", sender: self)
    }
    @IBAction func timeStepperValueChanged(sender: UIStepper) {
        timeField.text = String(sender.value)
    }
    @IBAction func timeFieldValueChanged(sender: UITextField) {
        if let text = sender.text {
            if let doubleValue = Double(text) {
                var newValue : Double
                if doubleValue <= 0 {
                    newValue = 0.0
                    sender.text = "0.0"
                } else {
                    newValue = doubleValue
                }
                timeStepper.value = newValue
            } else {
                sender.text = "0.0"
            }
        }
    }
    @IBAction func percentStepperValueChanged(sender: UIStepper) {
        percentField.text = String(sender.value)
    }
    @IBAction func percentFieldValueChanged(sender: UITextField) {
        if let text = sender.text {
            if let doubleValue = Double(text) {
                var newValue : Double
                if doubleValue > 100 {
                    newValue = 100.0
                    sender.text = "100.0"
                } else if doubleValue <= 0 {
                    newValue = 0.0
                    sender.text = "0.0"
                } else {
                    newValue = doubleValue
                }
                percentStepper.value = newValue
            } else {
                sender.text = "0.0"
            }
        }
    }

    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var sensorNamePicker: UIPickerView!
    @IBOutlet weak var percentStepper: UIStepper!
    @IBOutlet weak var percentField: UITextField!
    @IBOutlet weak var timeField: UITextField!

    var sensors = ["Water", "Humidity", "Temperature", "Light"]
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sensors[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sensors.count
    }
    
    var threshold : NotificationThreshold?
    var action : String?
    var plantID : Int?
    
    func capitalizedPhrase(phrase:String) -> String {
        return String(phrase.characters.prefix(1)).uppercaseString + String(phrase.characters.dropFirst())
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        timeStepper.minimumValue = 0.0
        percentStepper.minimumValue = 0.0
        percentStepper.maximumValue = 100.0
        
        timeStepper.value = Double((threshold?.deviationTime)!)
        timeField.text = String((threshold?.deviationTime)!)
        
        percentStepper.value = Double((threshold?.deviationPercent)!)
        percentField.text = String((threshold?.deviationPercent)!)
        
        sensorNamePicker.selectRow(sensors.indexOf(capitalizedPhrase(threshold!.name))!, inComponent: 0, animated: true)
        
        if action == "edit" {
            navigationBar.title = "Edit Threshold"
        } else {
            navigationBar.title = "New Threshold"
        }
        
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
