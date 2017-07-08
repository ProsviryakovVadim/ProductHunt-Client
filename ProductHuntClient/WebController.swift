//
//  WebController.swift
//  ProductHuntClient
//
//  Created by Vadim on 7/8/17.
//  Copyright © 2017 Vadim Prosviryakov. All rights reserved.
//

import UIKit
import KVNProgress

class WebController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var webUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        let url = URL(string: webUrl)
        webView.loadRequest(URLRequest(url: url!))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activity.isHidden = true
        activity.stopAnimating()
    }
}
