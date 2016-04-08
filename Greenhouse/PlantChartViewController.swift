//
//  PlantChartViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 4/6/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import SocketIOClientSwift

class PlantChartViewController: UIViewController, UITabBarDelegate, APIRequestDelegate {
    @IBOutlet weak var metricBar: UITabBar!
    
    @IBOutlet weak var waterItem: UITabBarItem!
    var sensorHistoryData: [String: [Double]]?
    var sensorIdealData: [String: Double]?
    var plantID : Int?
    var selectedSensor : String?
    
    var socket : SocketIOClient?
    
    @IBOutlet weak var radarChartView: RadarChartView!
    @IBOutlet weak var lineChartView: LineChartView!

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let metric = item.title!.lowercaseString
        self.selectedSensor = metric
        let labels = (0..<(sensorHistoryData?[metric]!.count)!).reverse().map({ val in "\(val * 10)" })
        setHistoryChart(metric, dataPoints: labels, values: sensorHistoryData![metric]!)
    }
    
    func displayHistoryChart(metric: String) {
        let labels = (0..<(sensorHistoryData?[metric]!.count)!).reverse().map({ val in "\(val * 10)" })
        setHistoryChart(metric, dataPoints: labels, values: sensorHistoryData![metric]!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Default to using water info
        self.selectedSensor = "water"
        metricBar.selectedItem = waterItem
        let apiRequest = APIRequest(urlString: "http://\(Config.greenhouse)/api/plants/\(plantID!)/logs")
        apiRequest.sendGETRequest(self)
        socket = SocketIOClient(socketURL: NSURL(string: "http://\(Config.greenhouse)")!, options: [.Nsp("/plants")])
        socket!.on("connect") {data, ack in
            print("Logs: socket connected")
        }
        socket!.on("data-update") {data, ack in
            apiRequest.sendGETRequest(self)
        }
        socket!.connect()
    }

    func handleData(data: NSData!) {
        sensorHistoryData = [:]
        sensorIdealData = [:]
        if let dataValue = data {
            let json = JSON(data: dataValue)
            let history = json["history"]
            let ideal = json["ideal"]
            for (sensor, _) in history.dictionary! {
                sensorHistoryData![sensor] = history.dictionary![sensor]!.dictionary!["datasets"]![0].dictionary!["data"]?.arrayObject as? [Double]
            }
            for idealDict in ideal.array! {
                sensorIdealData![idealDict["label"].string!.lowercaseString] = idealDict["value"].double!
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.setToleranceChart(self.sensorIdealData!)
            self.displayHistoryChart(self.selectedSensor!)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setToleranceChart(data: [String: Double]) {
        radarChartView.clear()
        var dataPoints : [String] = []
        var values : [Double] = []
        for (pt, val) in data {
            dataPoints.append(pt)
            values.append(val)
        }
        var dataEntries : [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let radarChartDataSet = RadarChartDataSet(yVals: dataEntries, label: "Percentage of Time Within Tolerance")
        radarChartDataSet.drawValuesEnabled = false
        radarChartDataSet.drawFilledEnabled = true
        let radarData = RadarChartData(xVals: dataPoints, dataSet: radarChartDataSet)
        radarChartView.data = radarData
        radarChartView.noDataText = "You need to provide data for the chart."
        radarChartView.descriptionText = ""
        radarChartView.drawMarkers = false
        radarChartView.yAxis.labelCount = 4
        radarChartView.yAxis.axisMaxValue = 100
        radarChartView.yAxis.axisMinValue = 0
        radarChartView.setNeedsDisplay()
        radarChartView.notifyDataSetChanged()
        radarChartView.hidden = false
        radarChartView.userInteractionEnabled = false
    }

    func setHistoryChart(label: String, dataPoints: [String], values: [Double]) {
        lineChartView.clear()
        var dataEntries : [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: label)
        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        let lineData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineData
        lineChartView.noDataText = "You need to provide data for the chart."
        lineChartView.descriptionText = ""
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.drawMarkers = false
        lineChartView.drawBordersEnabled = false
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftYAxisRenderer.yAxis?.drawAxisLineEnabled = true
        lineChartView.leftYAxisRenderer.yAxis?.drawGridLinesEnabled = false
        lineChartView.rightYAxisRenderer.yAxis?.drawAxisLineEnabled = false
        lineChartView.rightYAxisRenderer.yAxis?.drawGridLinesEnabled = false
        lineChartView.rightYAxisRenderer.yAxis?.drawLabelsEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.setNeedsDisplay()
        lineChartView.notifyDataSetChanged()
        lineChartView.hidden = false
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
