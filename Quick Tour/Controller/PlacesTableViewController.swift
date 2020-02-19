//
//  PlacesTableViewController.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
import Firebase
class PlacesTableViewController: UITableViewController , UISearchBarDelegate {
    
    var arrLocation: [Location] = []
    var arrLocationFind: [Location] = []
    var arrComment: [Comment] = []
    var name: String?
    @IBOutlet weak var seachBar: UISearchBar!
    var urlBooking: String?
    var urlWeather: String?
    var ref: DatabaseReference!
    var checkSreach = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = name
        seachBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        arrLocation = []
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        EZLoadingActivity.show("Loading...", disableUI: true)
        ref = Database.database().reference()
        ref.child(USER).child(COUNTRY).child(VN).child(DISTRICT).child(name ?? "").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            let location = snapshot.value as? DICT ?? [:]
            for (name,value) in location[LOCATION] as? DICT ?? [:]{
                let step = Location(name: name as! String, dict: value as! DICT)
                self.arrLocation.append(step)
            }
            
            self.urlBooking = location["Booking Hotel"] as? String ?? ""
            self.urlWeather = location["weather"] as? String ?? ""
            self.tableView.reloadData()
            EZLoadingActivity.hide()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(text: searchText)
        if !searchText.isEmpty && arrLocationFind.count == 0 {
            checkSreach = true
        }
        else {
            checkSreach = false
        }
        tableView.reloadData()
    }
    
    func filterTableView(text:String) {
        arrLocationFind = arrLocation.filter({ (value) -> Bool in
            return value.Name!.lowercased().contains(text.lowercased())
        })
    }
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
        if arrLocationFind.count > 0 {
            return arrLocationFind.count
        }
        else {
            return arrLocation.count
        }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlacesTableViewCell
        if !checkSreach{
        if arrLocationFind.count > 0 {
            cell.imagePlaces.download(from: arrLocationFind[indexPath.row].image!)
            cell.nameLabel.text = arrLocationFind[indexPath.row].Name
        }
        else {
            cell.imagePlaces.download(from: arrLocation[indexPath.row].image!)
            cell.nameLabel.text = arrLocation[indexPath.row].Name
        }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrComment = []
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailPlacesViewController") as? DetailPlacesViewController
        if arrLocationFind.count > 0 {
            for valueAuto in arrLocationFind[indexPath.row].comment ?? [:] {
                let data = valueAuto.value as? DICT ?? [:]
                for (key,value) in data{
                    let step = Comment(name: key as! String, comment:value as! String, keyAuto: valueAuto.key as! String)
                    self.arrComment.append(step)
                }
            }
            vc?.arrComment = self.arrComment
            vc?.name = arrLocationFind[indexPath.row].Name
            vc?.image = arrLocationFind[indexPath.row].image
            vc?.descriptionLB = arrLocationFind[indexPath.row].description
            vc?.DistrictName = self.name
            vc?.urlBooking = self.urlBooking
            vc?.urlWeather = self.urlWeather
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else {
            for valueAuto in arrLocation[indexPath.row].comment ?? [:] {
                let data = valueAuto.value as? DICT ?? [:]
                for (key,value) in data{
                    let step = Comment(name: key as! String, comment:value as! String, keyAuto: valueAuto.key as! String)
                    self.arrComment.append(step)
                }
            }
            vc?.arrComment = self.arrComment
            vc?.name = arrLocation[indexPath.row].Name
            vc?.image = arrLocation[indexPath.row].image
            vc?.descriptionLB = arrLocation[indexPath.row].description
            vc?.DistrictName = self.name
            vc?.urlBooking = self.urlBooking
            vc?.urlWeather = self.urlWeather
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
     
    }
    
    
}
