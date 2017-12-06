//進階篩選(頁碼代號:P2)
//Function:
//1.Make str to search Firebase's restaurant
//2.Return restaurant to P3
//3.Str For restaurant type
//4.Str For restaurant address
//Action:
//While click Search prepare str to P3 -> P3


import Foundation
import UIKit
import Firebase
import Speech

class pickerBlock:UIViewController, UITextFieldDelegate{
    

   
    @IBOutlet weak var textSearchTextField: UITextField!
    
    @IBOutlet weak var textSearchLable: UILabel!
    //所有縣市
    
    
    
   
    
    var countRow: Int =  0
    
    var pick = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "進階搜尋"
        
        textSearchTextField.delegate = self
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //傳數值到textSearch
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickerBlockSegue" {
            
            let destinationController = segue.destination as! textSearch
            destinationController.textSearch = textSearchTextField.text!
            
        }
        
        
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textSearchTextField.resignFirstResponder()
        
        return (true)
    }
    
    
    
   
    
}
