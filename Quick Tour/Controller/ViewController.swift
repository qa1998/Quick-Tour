//
//  ViewController.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var labelTour1: UILabel!
    @IBOutlet weak var labelTour2: UILabel!
    @IBOutlet weak var labelTour3: UILabel!
    @IBOutlet weak var labelNote1: UILabel!
    @IBOutlet weak var labelNote2: UILabel!
    @IBOutlet weak var labelNote3: UILabel!
    @IBOutlet weak var buttonGo: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
//    var rootRed: DatabaseReference!
//    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageControl.currentPage = 0
//        rootRed = Database.database().reference()
       
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x - pageNumber/2)/pageNumber)+1
        self.pageControl.currentPage = Int(currentPage)
    }
//    @IBAction func addText(_ sender: UIButton){
//            rootRed.child("name").setValue(nameTextField.text)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}

