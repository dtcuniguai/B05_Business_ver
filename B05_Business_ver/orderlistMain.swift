//
//  orderlistMain.swift
//  ios1
//
//  Created by Set on 07/11/2017.
//  Copyright © 2017 Niguai. All rights reserved.
//

import UIKit

class orderlistMain: UITableViewController {

    var orderlists:[Orderlist] = []
    
    override func viewDidLoad() {
        print("///////////HERE////////")
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        orderlists.removeAll()
        var urlStr: String = ""
        urlStr = "http://140.136.150.95:3000/orderlist/show/store?ID=\(AccountData.res_ID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlStr)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for orderlist in dic{
                        let order = Orderlist(orderID: orderlist["order_ID"] as! Int,
                                              userName: orderlist["user_Name"] as! String,
                                              orderTime: orderlist["DATE"] as! String,
                                              menuName: "",
                                              Totalprice: 0,
                                              price: 0,
                                              number: 0,
                                              menuID: 0,
                                              updateValue: 0,
                                              payTime: orderlist["pay_Time"] as! String)
                        self.orderlists.append(order)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //cell數量
    //Writer : Set
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderlists.count
    }

    //cell內容
    //Writer : Set
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderlistCell", for: indexPath) as! orderlistMainCell
        let order = orderlists[indexPath.item];
        
        cell.userName.text = order.userName
        cell.orderTime.text = order.orderTime
        if order.payTime != "NULL"{
            cell.orderlistStatus.text = "已出貨"
        }
        
        return cell
    }

    //Sending Value to orderlistDetail
    //Writer : Set
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOrderlistDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! orderlistDetail
                destinationController.orderlists = orderlists[indexPath.row]
            }
        }
    }
    
    
}
