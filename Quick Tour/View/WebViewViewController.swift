//
//  WebViewViewController.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Booking"
        webView.loadRequest(URLRequest(url: URL(string: url ?? "")!))
        if let text = webView.request?.url?.absoluteString{
            print(text)
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
