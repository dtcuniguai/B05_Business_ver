//
//  contentView.swift
//  B05_Business_ver
//
//  Created by 李季耕 on 2017/11/29.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import Foundation
import UIKit

class contentView:UITableViewController{
    
    var commentArray = [Comment]();
    var commentUrl =  "http://140.136.150.95:3000/comment/show/store?storeID=368";
    var index = 0;
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
    //Qry Menu Detail From DataBase
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func viewWillAppear(_ animated: Bool) {
        
        commentArray.removeAll()
        self.tableView.reloadData()
        let urlStr = commentUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let url = URL(string:urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for comment in dic {
                        let SearObj = Comment(ID: comment["ID"] as! Int,
                                           create_UserID:comment["create_UserID"] as! Int,
                                           storeID:comment["storeID"] as! Int,
                                           Memo:comment["Memo"] as! String,
                                           score:comment["Score"] as! Double,
                                           score_Envir: comment["Score_Envir"] as! Double ,
                                           score_Taste:comment["Score_Taste"] as! Double,
                                           score_Service:comment["Score_Service"] as! Double,
                                           AddTime:comment["AddTime"] as! String,
                                           user_Name:comment["user_Name"] as! String,
                                           store_Reply:comment["store_Reply"] as! String
                        );
                        self.commentArray.append(SearObj);
                    }
                    self.tableView.reloadData()
                }
            }
            
        }
        task.resume()
        
    }
    
    
    //顯示table的內容
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = commentArray[indexPath.item];
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! commentCell;
        cell.ID = comment.ID;
        cell.create_UserID = comment.create_UserID;
        cell.storeID = comment.storeID;
        cell.Memo = comment.Memo
        cell.score = comment.score
        cell.score_Envir = comment.score_Envir
        cell.score_Taste = comment.score_Taste
        cell.score_Service = comment.score_Service
        cell.AddTime.text = comment.AddTime
        cell.user_Name.text = comment.user_Name
        if(cell.store_Reply == "Empty"){
            cell.done.text = "尚未回復"
        }else{
            cell.done.text = "已回覆"
        }
        return cell;
        
    }
    
    
    //table的cell數量
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    
    //自訂tableView高度
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100.0;
    }
    
    
    //編輯按鈕並跳轉至下一頁面
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "回覆", handler: { (action, indexPath) -> Void in
            self.performSegue(withIdentifier: "commentReply", sender: self.tableView.cellForRow(at: indexPath))
            self.index = indexPath.row
        })
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        return [shareAction]
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentReply" {
            let destinationController = segue.destination as! contentDetail
            destinationController.comment = self.commentArray[self.index]
        }
    }
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
     }
    

    
}


class commentCell:UITableViewCell{
    
    @IBOutlet weak var user_Name: UILabel!
    @IBOutlet weak var AddTime: UILabel!
    @IBOutlet weak var done: UILabel!
    var ID:Int = 0
    var create_UserID:Int = 0
    var storeID:Int = 0
    var Memo:String = ""
    var score:Double = 0.0
    var score_Envir:Double = 0.0
    var score_Taste:Double = 0.0
    var score_Service:Double = 0.0
    var store_Reply:String = ""
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
