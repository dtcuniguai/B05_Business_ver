//新增會員
//Function:Create New Member Into Firebase
//Action:Create New Member And Goto MainMenu
//First Write By Niguai

import Foundation
import UIKit
import Firebase

class assignAccoutAction :UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var ScrollView: UIScrollView!
    //會員帳號(登入用)
    @IBOutlet weak var accountField: UITextField!
    //會員密碼(登入用)
    @IBOutlet weak var passwordField: UITextField!
    //會員名稱
    @IBOutlet weak var userNameField: UITextField!
    //會員電話
    @IBOutlet weak var phoneField: UITextField!
    //會員性別
    
    let refUserData = Database.database().reference().child("Accout")
    
    var sexuality = ["-----","男性","女性"]
    var careerArray = ["-----","學生","老師","公務員","軍人","工程師","司機","建築師","金融業","服務業","餐飲業","政治家"]
    
    var countRow: Int =  0
    
    
    var fullDay = ""
    var birthday = [String]()
    
    var pick = UIPickerView()
    let datePick = UIDatePicker()
    
    
    //主畫面顯示
    override func viewDidLoad() {
        super.viewDidLoad();
        
        pick.dataSource = self
        pick.delegate = self
        pick.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.donePressd))
        toolBar.setItems([doneButton], animated: false)
        
        title = "會員註冊"
        
        passwordField.delegate = self
        accountField.keyboardType = .emailAddress
        accountField.delegate = self
        phoneField.keyboardType = .numberPad
        phoneField.delegate = self
        userNameField.keyboardType = .namePhonePad
        userNameField.delegate = self
        phoneField.inputAccessoryView = toolBar
        
        
    }
    
    
    //創建新會員並跳至主頁面
    @IBAction func createAccout(_ sender: UIButton) {
        
        if userNameField.text != "" || accountField.text != "" || passwordField.text != ""  {
            if(passwordField.text!.characters.count>5){
                
                FirebaseAuth.Auth.auth().createUser(withEmail: accountField.text!, password: passwordField.text!){ (user,error) in
                    if error != nil {
                        self.Message(titleText: "錯誤", messageText: "此帳號已有人申請")
                    }else{
                        
                        
                        AccountData.user_Account = self.accountField.text!
                        AccountData.user_Password = self.passwordField.text!
                        AccountData.user_Name = self.userNameField.text!
                        AccountData.user_Type = "S"
                        AccountData.user_Tel = self.phoneField.text!
                        let main = self.storyboard?.instantiateViewController(withIdentifier: "storeID")
                        self.present(main!, animated: false, completion: nil)
                        
                        
                    }
                    
                }
               
            }
           else{
                self.Message(titleText: "錯誤", messageText: "密碼不可低於六個字")
            }
        }
        else {
            self.Message(titleText: "錯誤", messageText: "姓名,帳號或密碼為空白")
        }
    }
    
    
    //Create User Info
    //Focus:check textField if blank && password's textField's length must bigger than 5
    
    
    
    
    //選單地列數
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        return 1
        
    }
    //選單上要有幾個選項
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return countRow
        
    }
    
    //將Array的值傳入選單
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if countRow == sexuality.count{
            let titleRow = sexuality[row]
            return titleRow
        }
        
         
       else if countRow == careerArray.count {
            let titleRow = careerArray[row]
            return titleRow
        }
        
        return ""
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset((CGPoint(x: 0, y: -60)), animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        accountField.resignFirstResponder()
        passwordField.resignFirstResponder()
        userNameField.resignFirstResponder()
        return (true)
    }
    
    
    
    //Alert Message
    func Message(titleText : String, messageText : String ){
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {  (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func donePressd()  {
        view.endEditing(true)
    }
    
    
}
