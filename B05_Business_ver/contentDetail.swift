//
//  contentDetail.swift
//  B05_Business_ver
//
//  Created by 李季耕 on 2017/12/1.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import Foundation
import UIKit

class contentDetail:UIViewController{
    
    var comment:Comment?
    
    @IBOutlet weak var accountComment: UILabel!
    
    @IBOutlet weak var storeComment: UITextView!
    
    @IBOutlet weak var envirStar: CosmosView!
    
    @IBOutlet weak var tasteStar: CosmosView!
    
    @IBOutlet weak var serviceStar: CosmosView!
    
    @IBOutlet weak var scoreStar: CosmosView!
    
    override func viewDidLoad() {
        
        accountComment.layer.borderWidth = 1
        accountComment.layer.borderColor = UIColor.black.cgColor
        storeComment.layer.borderWidth = 1
        storeComment.layer.borderColor = UIColor.black.cgColor
        
        scoreStar.settings.fillMode = .half
        serviceStar.settings.fillMode = .half
        tasteStar.settings.fillMode = .half
        envirStar.settings.fillMode = .half
        
        envirStar.settings.updateOnTouch = false
        tasteStar.settings.updateOnTouch = false
        serviceStar.settings.updateOnTouch = false
        scoreStar.settings.updateOnTouch = false
        
        envirStar.rating = (comment?.score_Envir)!
        serviceStar.rating = (comment?.score_Service)!
        tasteStar.rating = (comment?.score_Taste)!
        scoreStar.rating = (comment?.score)!
        accountComment.text = comment?.Memo
        storeComment.text = comment?.store_Reply
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(contentDetail.donePressd))
        toolBar.setItems([doneButton], animated: false)
        
        storeComment.inputAccessoryView = toolBar
        
        
    }
    
    @IBAction func finshAction(_ sender: Any) {
        print(comment!.storeID)
        print(comment!.create_UserID)
        print(comment!.ID)
        let urlStr = "http://140.136.150.95:3000/comment/reply?content=\(storeComment.text!)&storeID=\(comment!.storeID)&userID=\(comment!.create_UserID)&commentID=\(comment!.ID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let content = String(data: data, encoding: .utf8){
                
                print(content)
            }
        }
        task.resume()
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func donePressd()  {
        
        view.endEditing(true)
        
    }
    
}
