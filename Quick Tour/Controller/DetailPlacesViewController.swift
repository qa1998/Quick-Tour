//
//  DetailPlacesViewController.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
import Firebase
class DetailPlacesViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var commentTxt: UITextField!
    @IBOutlet weak var likeImg: UIImageView!
    var arrComment: [Comment] = []
    var arrWeather: [ForeCastDay] = []
    var arrNameLocation: [String] = []
    var name: String?
    var image: String?
    var descriptionLB: String?
    var checkKeyborad = true
    var ref: DatabaseReference!
    var DistrictName: String?
    var urlBooking: String?
    var urlWeather: String?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = name
        nameLabel.text = name
        imagePlace.download(from: image!)
        commentTxt.delegate = self
        // set notification for keyborad display
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if checkKeyborad == false {
            commentTxt.endEditing(true)
        }
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func sendBtn(_ sender: UIButton) {
        sendValue()
    }
    @IBAction func detechTextFeildChange(_ sender: Any) {
        sendValue()
    }
    
    func sendValue(){
        if commentTxt.text != "" {
            self.ref = Database.database().reference()
            ref.child(USER).child(COUNTRY).child(VN).child(DISTRICT).child(DistrictName ?? "").child(LOCATION).child(name ?? "").child(COMMENT).childByAutoId().child(UserDefaults.standard.string(forKey: "name")!).setValue( commentTxt.text ?? "")
            commentTxt.text = ""
            arrComment = []
            ref.child(USER).child(COUNTRY).child(VN).child(DISTRICT).child(DistrictName ?? "").child(LOCATION).child(name ?? "").child(COMMENT).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                let comment = snapshot.value as? DICT ?? [:]
                for value in comment as? DICT ?? [:]{
                    for commentValue in value.value as? DICT ?? [:]{
                        let step = Comment(name: commentValue.key as! String, comment: commentValue.value as! String, keyAuto: value.key as! String)
                        self.arrComment.append(step)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checklikeImage()
        navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func checklikeImage(){
        arrNameLocation = []
        ref = Database.database().reference()
        // point to location user in firebase
        ref.child(USER_LOCATION).child(UserDefaults.standard.string(forKey: "name")!).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            for (name,_) in snapshot.value as? DICT ?? [:]{
                self.arrNameLocation.append(name as! String)
            }
            for name in self.arrNameLocation {
                if name == self.name{
                    self.likeImg.image = #imageLiteral(resourceName: "like")
                }
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
    // send data to user location in firebase
    @IBAction func changeImage(_ sender: UIButton) {
        if likeImg.image == #imageLiteral(resourceName: "like"){
            likeImg.image = #imageLiteral(resourceName: "unlike")
            self.ref = Database.database().reference()
            ref.child(USER_LOCATION).child(UserDefaults.standard.string(forKey: "name") ?? "").child(name ?? "").removeValue()
        }
        else {
            likeImg.image = #imageLiteral(resourceName: "like")
            self.ref = Database.database().reference()
            ref.child(USER_LOCATION).child(UserDefaults.standard.string(forKey: "name") ?? "").child(name ?? "").setValue(["Description":descriptionLB,"Rating":1,"id":1,"image":image,"district":self.DistrictName])
        }
        
    }
    
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if !checkKeyborad{
            self.view.frame.origin.y = self.view.frame.origin.y + keyboardHeight
            checkKeyborad = true
            }
        }
    }
    
    
    @IBAction func BookingButton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController
        vc?.url = self.urlBooking
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func weather(_ sender: UIButton) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        // get api weather
        DataService.apiWeather(url: urlWeather ?? "") { (weather) in
            self.arrWeather = weather.forecastDays
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookTickerViewController") as? BookTickerViewController
            vc?.arrWeather = self.arrWeather
            vc?.name = self.name
            self.navigationController?.pushViewController(vc!, animated: true)
            EZLoadingActivity.hide()
        }
    }
    
}
extension DetailPlacesViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 1
        }
        else {
            return arrComment.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        if indexPath.section == 0 {
            cell.descriptionLB.text =  descriptionLB
            cell.nameLabel.text = ""
            cell.commentLAbel.text = ""
            cell.backgroundColor = UIColor.white
            cell.deleteLabel.isHidden = true
        }
        else {
            if indexPath.section == 1 {
                cell.descriptionLB.text = "COMMENT"
                cell.backgroundColor = UIColor.lightGray
                cell.nameLabel.text = ""
                cell.commentLAbel.text = ""
                cell.deleteLabel.isHidden = true
            }
            else {
                cell.deleteLabel.tag = indexPath.row
                cell.delegate = self
                cell.backgroundColor = UIColor.white
                cell.descriptionLB.text = ""
                cell.nameLabel.text = arrComment[indexPath.row].name
                cell.commentLAbel.text = arrComment[indexPath.row].comment
                cell.deleteLabel.isHidden = true
                if arrComment[indexPath.row].name == UserDefaults.standard.string(forKey: "name"){
                    cell.deleteLabel.isHidden = false
                }
                else {
                    cell.deleteLabel.isHidden = true
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension DetailPlacesViewController: deleteCommentDelegate{
    func delete(index: Int) {
        let deleteAction = UIAlertAction(
        title: "Delete", style: UIAlertActionStyle.default) {
            (action) -> Void in
            EZLoadingActivity.show("Loading....", disableUI: true)
            self.ref = Database.database().reference()
            self.ref.child(USER).child(COUNTRY).child(VN).child(DISTRICT).child(self.DistrictName ?? "").child(LOCATION).child(self.name ?? "").child(COMMENT).child(self.arrComment[index].keyAuto ?? "").removeValue()
            self.arrComment.remove(at: index)
            self.tableView.reloadData()
            EZLoadingActivity.hide()
        }
        let cancel = UIAlertAction(
        title: "Cancel", style: UIAlertActionStyle.cancel) {
            (action) -> Void in
        }
        let alert = UIAlertController(title: "Notifition", message: "Do you want to delete this comment?", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
    }
    
}

class Comment{
    var name: String?
    var comment: String?
    var keyAuto: String?
    init(name: String , comment: String,keyAuto: String) {
        self.comment = comment
        self.name = name
        self.keyAuto = keyAuto
    }
}
