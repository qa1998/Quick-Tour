//
//  StartedViewController.swift
//  Quick Tour
//
//  Created by nguyễn hữu đạt on 7/4/18.
//  Copyright © 2018 nguyễn hữu đạt. All rights reserved.
//

import UIKit

class StartedViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if nameLabel != nil {
            UserDefaults.standard.set(nameLabel, forKey: "name")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
