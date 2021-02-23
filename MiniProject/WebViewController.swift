//
//  WebViewController.swift
//  MiniProject
//
//  Created by Nikunjkumar Patel on 17/02/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate  {

    var webView: WKWebView!
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: urlString ?? "https://www.blibli.com/")!
           webView.load(URLRequest(url: url))

           let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
           toolbarItems = [refresh]
           navigationController?.isToolbarHidden = false
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        }
}
