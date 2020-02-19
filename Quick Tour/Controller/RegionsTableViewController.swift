//
//  RegionsTableViewController.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
import Firebase

class RegionsTableViewController: UITableViewController,UISearchBarDelegate {
    
    
    var ref: DatabaseReference!
    var arrDisrict: [ModelDistrict] = []
    var arrDisrictFind: [ModelDistrict] = []
    var arrLocation: [Location] = []
    var checkSreach = false
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find Place"
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrDisrict = []
        getDataFromFireBase()
        navigationController?.isNavigationBarHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as? PlaceTableViewCell
            filterTableView(text: searchText)
        if !searchText.isEmpty && arrDisrictFind.count == 0 {
            checkSreach = true
        }
        else {
            checkSreach = false
        }
        tableView.reloadData()
    }
    
    func filterTableView(text:String) {
            arrDisrictFind = arrDisrict.filter({ (value) -> Bool in
                return value.name!.lowercased().contains(text.lowercased())
            })
    }
    // get data district from firebase
    //18/04/2019
    func getDataFromFireBase(){
        EZLoadingActivity.show("Loading...", disableUI: true)
        ref = Database.database().reference()
        ref.child(USER).child(COUNTRY).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            let country = snapshot.value as? DICT ?? [:]
            if let vietNam = country[VN] as? DICT {
                for (name,value) in vietNam[DISTRICT] as? DICT ?? [:]{
                    let step = ModelDistrict(name: name as! String, dict: value as? DICT ?? [:])
                    self.arrDisrict.append(step)
                }
                self.tableView.reloadData()
                EZLoadingActivity.hide()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if checkSreach{
            return 0
        }
        else {
        if arrDisrictFind.count > 0 {
            return arrDisrictFind.count
        }
        else {
        return arrDisrict.count
        }
        }
    }
    
    // fill data to tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as? PlaceTableViewCell
        if !checkSreach{
        if arrDisrictFind.count > 0 {
            cell?.nameLb?.text = arrDisrictFind[indexPath.row].name
            cell?.imageN?.download(from: arrDisrict[indexPath.row].thumnailsImage!)
        }
        else {
        cell?.nameLb?.text = arrDisrict[indexPath.row].name
        cell?.imageN?.download(from: arrDisrict[indexPath.row].thumnailsImage!)
        }
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlacesTableViewController") as? PlacesTableViewController
        if arrDisrictFind.count > 0 {
        vc?.name = arrDisrictFind[indexPath.row].name
        }
        else {
            vc?.name = arrDisrict[indexPath.row].name
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
}
