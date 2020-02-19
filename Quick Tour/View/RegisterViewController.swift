//
//  RegisterViewController.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var passWordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    var checkType: Bool?
    var arrUserName: [String] = []
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
         title = "Register"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
   
    
    @IBAction func registerBtn(_ sender: UIButton) {
        
        
        
        if  self.setText(arrUserName: arrUserName) {
            
        }
        else {
        }
            }
    func setText(arrUserName: [String]) -> Bool{
        // validate
        //dungnd
        //19/04/2019
        var checkDuplicate = false
        if nameTxt.text?.isEmpty == true || passWordTxt.text?.isEmpty == true || confirmPasswordTxt.text?.isEmpty == true{
            showAlert(message: "Do not input empty field", title: "Error", vc: self)
            return false
        }
        else {
            if nameTxt.text!.count < 7 || passWordTxt.text!.count < 7 || confirmPasswordTxt.text!.count < 7 {
                showAlert(message: "The characters must more than 7", title: "Error", vc: self)
                return false
            }
            else {
                if passWordTxt.text != confirmPasswordTxt.text {
                    showAlert(message: "The confirm password is wrong", title: "Error", vc: self)
                    return false
                }
                else {
                    for i in arrUserName {
                        if nameTxt.text == i {
                           showAlert(message: "This username is existed", title: "Error", vc: self)
                            checkDuplicate = true
                            break
                        }
                    }
                    if !checkDuplicate {
                        // send value to firebase
                    self.ref = Database.database().reference()
                    self.ref.child(USER_LOGIN).child(nameTxt.text!).setValue(passWordTxt.text)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UItarbarController") as? UItarbarController
                         UserDefaults.standard.set(nameTxt.text, forKey: "name")
                        UserDefaults.standard.set(passWordTxt.text, forKey: "pw")
                        self.navigationController?.pushViewController(vc!, animated: true)
                        return true
                    }
                    return false
                    
                }
            }
        }
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
