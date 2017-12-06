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
    @IBOutlet weak var sexualityField: UITextField!
    //會員性別選單
    //生日 年
    @IBOutlet weak var birthdayYear: UITextField!
    //職業
    @IBOutlet weak var career: UITextField!
    
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
        creatDatePicker()
        
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
        sexualityField.inputView = pick
        career.inputView = pick
        phoneField.inputAccessoryView = toolBar
        sexualityField.inputAccessoryView = toolBar
        career.inputAccessoryView = toolBar
        
        
    }
    
    
    //創建新會員並跳至主頁面
    @IBAction func createAccout(_ sender: UIButton) {
        
        if userNameField.text != "" || accountField.text != "" || passwordField.text != ""  {
            if(passwordField.text!.characters.count>5){
                
                FirebaseAuth.Auth.auth().createUser(withEmail: accountField.text!, password: passwordField.text!){ (user,error) in
                    if error != nil {
                        self.Message(titleText: "錯誤", messageText: "此帳號已有人申請")
                    }else{
                        self.creatUserData()
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
    
    
    func creatUserData(){
        
        /*let user = Auth.auth().currentUser?.uid
        let userData = ["Email": accountField.text! as String,
                        "PassWord": passwordField.text! as String
        ]
        refUserData.child(user!).setValue(userData)*/
        
        //
        
        
        let birthday = fullDay.characters.split{$0 == "/"}.map(String.init)
        
        
        if sexualityField.text == "男生"{
            AccountData.user_Gender = "B"
        }
        else{
            AccountData.user_Gender = "G"
        }
        
        let urlStr = "http://140.136.150.95:3000/user/register?account=\(accountField.text!)&password=\(passwordField.text!)&userType=\("S")&name=\(userNameField.text!)&gender=\(AccountData.user_Gender)&career=\(career.text!)&month=\(birthday[1])&day=\(birthday[0])&year=\(birthday[2])&phone=\(phoneField.text!)&userPic=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                
                if content.count != 0 {
                    
                    self.signUpMesssage()
                }
                else{
                    self.Message(titleText: "錯誤", messageText: "此帳號已有人申請")
                }
            }
        }
        task.resume()
        
        
        
        
        
    }
    
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
    
    
    //點擊選單後要做的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if countRow == sexuality.count {
            if sexuality[row] != "-----"{
                self.sexualityField.text = self.sexuality[row]
            }
            else{
                self.sexualityField.text = ""
            }
        }
         else if countRow == careerArray.count {
            if careerArray[row] != "-----" {
                self.career.text = self.careerArray[row]
            }
            else {
                self.sexualityField.text = ""
            }
        }
    }
    
    
    //點選指定的textField要的事情
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        ScrollView.setContentOffset((CGPoint(x: 0, y: 120)), animated: true)
        
        if (textField == self.sexualityField){
            
            countRow = sexuality.count
   
        }
        
        else if textField == self.career {
            
            countRow = careerArray.count
            
        }
        else if textField == self.birthdayYear{
            
            creatDatePicker()
        
        }
    
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
    
    
    ///// Ssuccess Sign UP Message
    
    func signUpMesssage() {
        
        let alert = UIAlertController(title: "登入訊息", message: "歡迎加入" + userNameField.text!, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
            
            let urlStr = "http://140.136.150.95:3000/user/login?account=\(self.accountField.text!)&password=\(self.passwordField.text!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlStr!)
            let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
                if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                    DispatchQueue.main.async {
                        for userData in dic{
                            AccountData.user_ID = userData["user_ID"]! as! Int
                            AccountData.user_Account = userData["user_Account"] as! String
                            AccountData.user_Name = userData["user_Name"] as! String
                            AccountData.user_Type = userData["user_Type"] as! String
                            AccountData.user_Gender = userData["user_Gender"] as! String
                            AccountData.user_Career = userData["user_Career"] as! String
                            AccountData.user_Day = userData["user_Day"] as! String
                            AccountData.user_Month = userData["user_Month"] as! String
                            AccountData.user_Year = userData["user_Year"] as! String
                            AccountData.user_Tel = userData["user_Tel"] as! String
                            
                        }
                    }
                }
            }
            task.resume()
            
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "storeID")
            self.present(main!, animated: false, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func creatDatePicker() {
        datePick.datePickerMode = UIDatePickerMode.date
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.dateDonePressd))
        toolBar.setItems([doneButton], animated: false)
        
        birthdayYear.inputAccessoryView = toolBar
    
        birthdayYear.inputView = datePick
    }
    
    @objc func dateDonePressd() {
       
            let dateFormattet = DateFormatter()
            dateFormattet.dateStyle = .short
            dateFormattet.timeStyle = .none
            birthdayYear.text = dateFormattet.string(from: datePick.date)
            fullDay = birthdayYear.text!
            view.endEditing(true)
    }
    
    
    @objc func donePressd()  {
        view.endEditing(true)
    }
    
    
}
