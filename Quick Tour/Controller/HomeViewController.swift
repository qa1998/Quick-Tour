//
//  HomeViewController.swift
//  LoginFaceBook
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    var arrUserLocation: [Location] = []
    static var instance: HomeViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.setHidesBackButton(true, animated:false)
        // set data to label name
        userName.text = " \(UserDefaults.standard.object(forKey: "name") as? String ?? "")"
        //tableView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserLocation()
        navigationController?.isNavigationBarHidden = true
    }
    

    // get place user liked
    func getUserLocation(){
        arrUserLocation = []
        EZLoadingActivity.show("Loading...", disableUI: true)
        ref = Database.database().reference()
        // point to location user in firebase
        ref.child(USER_LOCATION).child(UserDefaults.standard.string(forKey: "name")!).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            for (name,value) in snapshot.value as? DICT ?? [:]{
                let step = Location(name: name as! String, dict: value as! DICT)
                self.arrUserLocation.append(step)
            }
            EZLoadingActivity.hide()
            self.tableView.reloadData()
        }
    }
    @IBAction func logOut(_ sender: UIButton) {
        let logOutManager = FBSDKLoginManager()
        logOutManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        UserDefaults.standard.removeObject(forKey: "Me")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginFBViewController") as? LoginFBViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        UserDefaults.standard.set(false, forKey: FLAG_LOGIN)
    }
    @IBAction func changePassword(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "pw") == "" {
            showAlert(message: "Login Facebook Do not change Pass", title: "Error", vc: self)
        }
        else {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassWordViewController") as? ChangePassWordViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}
extension HomeViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserLocation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // fill data for table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as? HomeTableViewCell
        cell?.nameLAbel.text = arrUserLocation[indexPath.row].Name
        cell?.imageViewNew.download(from: arrUserLocation[indexPath.row].image!)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        var arrComment: [Comment] = []
        var urlBooking: String?
        var urlWeather: String?
        
        ref = Database.database().reference()
        ref.child(USER).child(COUNTRY).child(VN).child(DISTRICT).child(arrUserLocation[indexPath.row].district ?? "").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            let location = snapshot.value as? DICT ?? [:]
            for (name,value) in location[LOCATION] as? DICT ?? [:]{
                if name as? String ?? "" == self.arrUserLocation[indexPath.row].Name ?? "" {
                    let valueNew = value as? DICT ?? [:]
                    for valueAuto in valueNew["Comment"] as? DICT ?? [:]{
                        let valueNew = valueAuto.value as? DICT ?? [:]
                        for (key,value) in valueNew{
                            let step = Comment(name: key as! String, comment:value as! String, keyAuto: valueAuto.key as! String)
                        arrComment.append(step)
                        }
                    }
                    break
                }
                
            }
           urlBooking = location["Booking Hotel"] as? String ?? ""
           urlWeather = location["weather"] as? String ?? ""

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailPlacesViewController") as? DetailPlacesViewController
            vc?.arrComment = arrComment
            vc?.name = self.arrUserLocation[indexPath.row].Name ?? ""
            vc?.image = self.arrUserLocation[indexPath.row].image ?? ""
            vc?.descriptionLB = self.arrUserLocation[indexPath.row].description
            vc?.DistrictName = self.arrUserLocation[indexPath.row].district ?? ""
            vc?.urlBooking = urlBooking
            vc?.urlWeather = urlWeather
            self.navigationController?.pushViewController(vc!, animated: true)
            EZLoadingActivity.hide()
        }
        
        
        
    }
}
