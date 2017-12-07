//
//  manage.swift
//  B05_Business_ver
//
//  Created by 李季耕 on 2017/12/2.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import Foundation
import UIKit
import Charts

class manage:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate{
    
    var monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var temperatureArray:[Double] = [20, 21, 22, 23, 24, 25, 26, 27, 28, 29 ,30, 31, 32,20, 21, 22, 23, 24, 25, 26, 27, 28, 29 ,30, 31, 32,20, 21, 22, 23, 24, 25, 26, 27, 28, 29 ,30, 31, 32]
    var axisFormatDelgate: IAxisValueFormatter?
    @IBOutlet var chartView: BarChartView!
    var dateArray = [String]()
    var X = [String]()
    
    @IBOutlet weak var selectItem: UITextField!
    @IBOutlet var pickerType: UITextField!
    
    var pickerArray = ["總計"];
    var pickerTypeArray = ["訂單","金額"]
    var pickerArrayID = [0];
    var pick = UIPickerView()
    
    var menuUrl = "http://140.136.150.95:3000/menu/detail/store?storeID=\(AccountData.user_ID)";
    var key:Int = 0
    var pickerID:Int = 0
    
    
    override func viewDidLoad() {
        //picker Init
        pick.dataSource = self
        pick.delegate = self
        pick.showsSelectionIndicator = true
        //picker Field Init
        selectItem.inputView = pick
        selectItem.delegate = self
        pickerType.inputView = pick
        pickerType.delegate = self
        //
        GetItemSelectArray()
        
        InsertChartsData()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerID == 0){
            return pickerArray.count
        }else{
            return pickerArrayID.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerID == 0){
            return pickerArray[row]
        }else{
            return pickerTypeArray[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerID == 0){
            self.selectItem.text = pickerArray[row]
            key = pickerArrayID[row]
        }else{
            self.pickerType.text = pickerArray[row]
        }
        donePressd();
        
    }
    
    
    @objc func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    @objc func donePressd()  {
        view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == self.selectItem){
            pickerID = 0;
        }else if(textField == self.pickerType){
            pickerID = 1;
        }
        
    }
    
    
    func InsertChartsData() {
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<monthArray.count {
            let dataEntry = BarChartDataEntry(x:Double(i),  y:temperatureArray[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Temperature per month")
        let charData = BarChartData(dataSet: chartDataSet)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthArray)
        chartView.xAxis.granularity = 1
        chartView.data = charData
    
    }
    
    
//Get menu Item insert into Select Array
    func GetItemSelectArray() {
        
        let urlStr = menuUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let url = URL(string:urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for menu in dic {
                        let name = menu["name"] as! String
                        let ID = menu["ID"] as! Int
                        self.pickerArray.append(name);
                        self.pickerArrayID.append(ID);
                    }
                }
            }
        }
        task.resume()
    }
    
}
