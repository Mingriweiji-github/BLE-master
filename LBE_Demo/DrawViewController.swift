//
//  DrawViewController.swift
//  LBE_Demo
//
//  Created by Seven on 2019/4/3.
//  Copyright © 2019年 LuoKeRen. All rights reserved.
//

import Charts

class DrawViewController:UIViewController {
    let lineChartView = LineChartView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createChartView()
    }
    
    func createChartView(){
        LineChartView = LineChartView(frame: CGRect(x: 100, y: 100, width: UIScreen.main.bounds.width - 200, height: UIScreen.main.bounds.height - 300))
        lineChartView.backgroundColor = UIColor.white
        lineChartView.delegate = self
        self.view.addSubview(lineChartView)
    }
    func setData(dataPoints:[String],values:[String]){
        var dataEntries:[ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: <#T##Double#>, y: <#T##Double#>, data: <#T##AnyObject?#>)
            
        }
        
    }
}

