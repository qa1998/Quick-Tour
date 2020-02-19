//
//  ViewController.swift
//  LoginFaceBook
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginFBViewController: UIViewController , UITextFieldDelegate {
    
    let fbloginManager: FBSDKLoginManager = FBSDKLoginManager()
    var ref: DatabaseReference!
    var arrUserName: [String] = []
    var arrPassword: [String] = []
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passWordTxt: UITextField!
    var checkName = false
    var checkPassWord = false
    var userNameStr: String?
    var checkKeyborad = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        EZLoadingActivity.show("Loading...", disableUI: true)
       // get data user Login from firebase
        ref = Database.database().reference()
        ref.child(USER_LOGIN).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            for (name,password) in snapshot.value as? DICT ?? [:]{
                self.arrUserName.append(name as? String ?? "")
                self.arrPassword.append(password as? String ?? "")
            }
            EZLoadingActivity.hide()
            
        }
        self.userNameTxt.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if checkKeyborad == false {
            userNameTxt.endEditing(true)
            passWordTxt.endEditing(true)
        }
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userNameTxt.endEditing(true)
        passWordTxt.endEditing(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if !checkKeyborad {
            self.view.frame.origin.y = self.view.frame.origin.y + keyboardHeight
            checkKeyborad = true
            }
        }
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if checkKeyborad {
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardHeight
                checkKeyborad = false
            }
        }
    }
    
    func checkLogin (){
         checkName = false
         checkPassWord = false
        for name in arrUserName{
            if (self.userNameTxt.text?.elementsEqual(name))!{
                checkName = true
                UserDefaults.standard.set(name, forKey: "name")
                break
            }
        }
        for password in arrPassword {
            if (self.passWordTxt.text?.elementsEqual(password))!{
                checkPassWord = true
                break
            }
        }
        // if success login , push to my page screen
        if checkName && checkPassWord {
            presentHomeViewController()
            UserDefaults.standard.set(passWordTxt.text, forKey: "pw")
        }
        else {
        showAlert(message: "Login Fail", title: "Error", vc: self)
        }
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        checkLogin()
    }
    
    @IBAction func login(_ sender: UIButton){
        fbloginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error == nil{
                if let loginResult = result {
                    if loginResult.grantedPermissions != nil {
                        self.getFBUserData()
                        UserDefaults.standard.set("", forKey: "pw")
                    }
                }
                else{
                    showAlert(message: "Login Fail", title: "Error", vc: self)
                }
            }
        }
    }
    // login with facebook
    func getFBUserData(){
        //
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                guard let info = result as? DICT else { return }
                guard let picture = info["picture"] as? DICT else {return}
                guard let data = picture["data"] as? DICT else {return}
                guard let url = data["url"] as? String else {return}
                guard let id = info["id"] as? String else {return}
                guard let name = info["name"] as? String else {return}
                // if login facebook success
                UserDefaults.standard.set(name, forKey: "name")
                UserDefaults.standard.set(url, forKey: "url")
                // push to my page
                self.presentHomeViewController()
            }
        })
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func presentHomeViewController() {
        UserDefaults.standard.set(true, forKey: FLAG_LOGIN)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UItarbarController") as? UItarbarController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

