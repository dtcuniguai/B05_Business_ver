//
//  orderlistDetail.swift
//  ios1
//
//  Created by Set on 07/11/2017.
//  Copyright © 2017 Niguai. All rights reserved.
//

import UIKit

class orderlistDetail: UITableViewController {

    var orderlists: Orderlist!
    var orderArray = [Orderlist]()
    
    //connect database
    //Writer : Set
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlStr = "http://140.136.150.95:3000/orderlist/detail/store?orderID=\(orderlists.orderID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for detail in dic{
                        let orders = Orderlist(orderID: 0,
                                               userName: "",
                                               orderTime: "",
                                               menuName: (detail["name"] as? String)!,
                                               Totalprice: (detail["Totalprice"] as? Int)!,
                                               price: (detail["price"] as? Int)!,
                                               number: (detail["number"] as? Int)!,
                                               menuID: (detail["ID"] as? Int)!,
                                               updateValue: (detail["updateValue"] as? Int)!
                        )
                        self.orderArray.append(orders)
                        self.orderlists.Totalprice += orders.Totalprice
                    }
                    self.tableView.reloadData()
                    
                }
            }
        }
        task.resume()
    }

    //doneButton Action
    //Writer : Set
    @IBAction func doneButtonAction(_ sender: Any) {
        Message()
    }
    
    //Alert Message
    //Writer : Set
    func Message(){
        let alert = UIAlertController(title: "訂單", message: "確定已完成訂單？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: {  (action) in
            let urlStr = "http://140.136.150.95:3000/orderlist/done?orderID=\(self.orderlists.orderID)&menuID=\(self.orderlists.menuID)&total=\(self.orderlists.updateValue)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlStr!)
            let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
                if let data = data, let _ = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                }
            }
            task.resume()
            self.AlertMessage()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: {  (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Alert Message
    //Writer : Set
    func AlertMessage(){
        let alert = UIAlertController(title: "訂單", message: "訂單已完成", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
            self.navigationController?.popViewController(animated: true)
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //cell數量
    //Writer : Set
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (orderArray.count + 4)
    }

    //cell content
    //Writer : Set
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderlistDetailCell", for: indexPath) as! orderlistDetailCell
        
        if indexPath.item == 0 {
            cell.menuLabel.text = "訂單人:"
            cell.numberLabel.text = orderlists.userName
            cell.priceLabel.text = "訂單時間:"
            cell.totalLabel.text = orderlists.orderTime
            cell.doneButton.isHidden = true
        }
        else if indexPath.item == 1 {
            cell.menuLabel.text = "菜名"
            cell.numberLabel.text = "數量"
            cell.priceLabel.text = "單價"
            cell.totalLabel.text = "總價"
            cell.doneButton.isHidden = true
        }
        else if indexPath.item == orderArray.count + 2 {
            cell.menuLabel.isHidden = false
            cell.numberLabel.isHidden = true
            cell.priceLabel.isHidden = false
            cell.totalLabel.isHidden = true
            cell.doneButton.isHidden = true
            cell.menuLabel.text = "總金額"
            cell.priceLabel.text = String(orderlists.Totalprice)
        }
        else if indexPath.item == orderArray.count + 3 {
            cell.menuLabel.isHidden = true
            cell.numberLabel.isHidden = true
            cell.priceLabel.isHidden = true
            cell.totalLabel.isHidden = true
            cell.doneButton.isHidden = false
        }
        else{
            let order = orderArray[(indexPath.item - 2)]
            cell.menuLabel.isHidden = false
            cell.numberLabel.isHidden = false
            cell.priceLabel.isHidden = false
            cell.totalLabel.isHidden = false
            cell.menuLabel.text = order.menuName
            cell.numberLabel.text = String(order.number)
            cell.priceLabel.text = String(order.price)
            cell.totalLabel.text = String(order.Totalprice)
            cell.doneButton.isHidden = true
        }

        return cell
    }
}
