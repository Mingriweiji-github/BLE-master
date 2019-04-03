//
//  DrawViewController.swift
//  LBE_Demo
//
//  Created by Seven on 2019/4/3.
//  Copyright © 2019年 LuoKeRen. All rights reserved.
//

import Charts

class DrawViewController:UIViewController {
    var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createChartView()
    }
    
    func createChartView(){
        lineChartView = LineChartView(frame: CGRect(x: 100, y: 100, width: UIScreen.main.bounds.width - 200, height: UIScreen.main.bounds.height - 300))
        lineChartView.backgroundColor = UIColor.white
        lineChartView.delegate = self
        self.view.addSubview(lineChartView)
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .topInside
        xAxis.labelFont = .systemFont(ofSize: 10)
//        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 3600
        xAxis.valueFormatter = DateFormatter() as? IAxisValueFormatter
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = -300
        leftAxis.axisMaximum = 300
        leftAxis.yOffset = -9
        leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.form = .line
        
        lineChartView.animate(xAxisDuration: 2.5)
    }
    func setDataCount(_ count: Int,range: UInt32)  {
        let now = Date().timeIntervalSince1970
        let hourSeconds: TimeInterval = 3600
        let from = now - (Double(count) / 2) * hourSeconds
        let to = now + (Double(count) / 2) * hourSeconds
        
        let values = stride(from: from, to: to, by: hourSeconds).map{(x) -> ChartDataEntry in
            let y  = arc4random_uniform(range) + 50
            return ChartDataEntry(x: x, y: Double(y))
        }
        
        let set1 = LineChartDataSet(values: values, label: "Date Set 1")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 255/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.lineWidth = 1.5
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        set1.fillAlpha = 0.26
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        lineChartView.data = data
    }
//    func setData(dataPoints:[String],values:[Double]){
//        var dataEntries:[ChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
//            dataEntries.append(dataEntry)
//        }
//
//        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
//        let chartData = LineChartData(
//    }
}

