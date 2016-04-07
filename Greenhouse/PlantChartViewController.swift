//
//  PlantChartViewController.swift
//  Greenhouse
//
//  Created by Chase Conklin on 4/6/16.
//  Copyright © 2016 ECESeniorDesign. All rights reserved.
//

import UIKit
import Charts

class PlantChartViewController: UIViewController, UITabBarDelegate {
    @IBOutlet weak var metricBar: UITabBar!
    
    @IBOutlet weak var waterItem: UITabBarItem!
    var sensorHistoryData: [String: [Double]]?
    var sensorIdealData: [String: Double]?
    
    @IBOutlet weak var radarChartView: RadarChartView!
    @IBOutlet weak var lineChartView: LineChartView!

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let metric = item.title!.lowercaseString
        let labels = (0..<(sensorHistoryData?[metric]!.count)!).reverse().map({ val in "\(val * 10)" })
        setHistoryChart(metric, dataPoints: labels, values: sensorHistoryData![metric]!)
    }
    
    func displayHistoryChart(metric: String) {
        let labels = (0..<(sensorHistoryData?[metric]!.count)!).reverse().map({ val in "\(val * 10)" })
        setHistoryChart(metric, dataPoints: labels, values: sensorHistoryData![metric]!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Don't hardcode
        sensorHistoryData = [
            "light": [10.0, 20.0, 30.0, 40.0],
            "water": [50.0, 40.0, 70.0, 20.0],
            "humidity": [10, 30, 20, 40],
            "temperature": [55.0, 65.0, 75.0, 85.0]
        ]
        sensorIdealData = ["water": 57.0, "light": 93.0, "temperature": 22.1, "humidity": 76.8]

        setToleranceChart(sensorIdealData!)

        // Default to using water info
        metricBar.selectedItem = waterItem
        displayHistoryChart("water")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setToleranceChart(data: [String: Double]) {
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
    }

    func setHistoryChart(label: String, dataPoints: [String], values: [Double]) {
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
