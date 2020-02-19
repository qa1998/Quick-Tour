//
//  ChangePassWordViewController.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
import Firebase

class ChangePassWordViewController: UIViewController {

    @IBOutlet weak var oldPassWord: UITextField!
    @IBOutlet weak var newPassWord: UITextField!
    @IBOutlet weak var confirmNewPassWord: UITextField!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
 navigationController?.isNavigationBarHidden = false
        
        // Do any additional setup after loading the view.
    }

    @IBAction func changePass(_ sender: UIButton) {
        setText()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setText(){
        
        if oldPassWord.text?.isEmpty == true || newPassWord.text?.isEmpty == true || confirmNewPassWord.text?.isEmpty == true{
            showAlert(message: "Do not input empty field", title: "Error", vc: self)
        }
        else {
            if oldPassWord.text!.count < 7 || newPassWord.text!.count < 7 || confirmNewPassWord.text!.count < 7 {
                showAlert(message: "The characters must more than 7", title: "Error", vc: self)
            }
            else {
                if newPassWord.text != confirmNewPassWord.text {
                    showAlert(message: "The confirm password is wrong", title: "Error", vc: self)
                }
                else {
                    if UserDefaults.standard.string(forKey: "pw") != oldPassWord.text{
                        showAlert(message: "Old Pass Wrong", title: "Error", vc: self)
                    }
                    else {
                        self.ref = Database.database().reference()
                    self.ref.child(USER_LOGIN).child(UserDefaults.standard.string(forKey: "name")!).setValue(newPassWord.text ?? "")
                    showAlert(message: "ChangePassWord Success", title: "OK", vc: self)
                    UserDefaults.standard.set(newPassWord.text, forKey: "pw")
                    oldPassWord.text = ""
                    newPassWord.text = ""
                    confirmNewPassWord.text = ""
                    }
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
