//
//  restaurantDetail.swift
//  ios1
//
//  Created by Set on 2017/10/10.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class restaurantDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var restaurantImage: UIImageView!//餐廳圖片
    @IBOutlet weak var restaurantDetailTable: UITableView!//餐廳資料的table
    
    var restaurant: Restaurant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if restaurant.ResImage != nil {
            let url_restaurant = URL(string: restaurant.ResImage!)
            let data = NSData(contentsOf: url_restaurant!)
            restaurantImage.image = UIImage(data: data! as Data)
        }*/
        
        title = restaurant.Name
        AccountData.res_ID = restaurant.ResID

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item < 5{
            return 50.0
        }
        
        return 90.0
    }
    
    
    //cell的數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }
    
    //顯示table的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = restaurantDetailTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! restaurantDetailCell
            
            switch indexPath.row{
            case 0:
                cell.fieldLabel.text = "店名"
                cell.valueLabel.text = restaurant.Name
            case 1:
                cell.fieldLabel.text = "類別"
                cell.valueLabel.text = restaurant.ResType
            case 2:
                cell.fieldLabel.text = "電話"
                cell.valueLabel.text = restaurant.ResPhone
            case 3:
                cell.fieldLabel.text = "地址"
                cell.valueLabel.text = restaurant.ResAddress
            case 4:
                cell.fieldLabel.text = "均消"
                cell.valueLabel.text = restaurant.ResCost
            case 5:
                cell.fieldLabel.text = "店家資訊"
                
                cell.valueLabel.text = restaurant.ResInfo
                
                
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
            }
            return cell
        
    }
    

    //設定footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        footerView.backgroundColor = UIColor.white
        
        return footerView
    }
    

    
    @IBAction func joinToStoreID(_ sender: Any) {
        let urlStr = "http://140.136.150.95:3000/user/storeRegister?storeID=\(restaurant.ResID)&userID=\(AccountData.user_ID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                
            }
        }
        task.resume()
        
        AccountData.res_ID = restaurant.ResID
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "storeMenu")
        self.present(main!, animated: false, completion: nil)
    }
    
    
}


