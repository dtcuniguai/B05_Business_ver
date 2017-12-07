//
//  Main.swift
//  B05_Business_ver
//
//  Created by maartenwei on 2017/12/4.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit
import FirebaseAuth

class Main: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        
        if Auth.auth().currentUser != nil{
            
            do{
                
                try  Auth.auth().signOut()
                signOutMesssage()
                
            }catch let error as NSError{
                
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    
    func signOutMesssage() {
        
        let alert = UIAlertController(title: "登出訊息", message: "歡迎再度光臨", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
            
            let logIn = self.storyboard?.instantiateViewController(withIdentifier: "logIn")
            self.present(logIn!, animated: false, completion: nil)
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
