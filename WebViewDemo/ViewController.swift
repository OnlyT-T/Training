//
//  ViewController.swift
//  WebViewDemo
//
//  Created by Tran Thanh Trung on 04/01/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var reloadDisplay: UIActivityIndicatorView!
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
                
                let config = WKWebViewConfiguration()
                config.allowsInlineMediaPlayback = true
                
                webView = WKWebView(frame: view.bounds, configuration: config)
                
                self.view = webView
        
                let url = URL(string: "https://theconversation.com/au")!

                let request = URLRequest(url: url)
                webView.load(request)
                webView.allowsBackForwardNavigationGestures = true
        
        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(backTapped))
        let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadTapped))
        let next = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(nextTapped))
        navigationItem.title = "https://theconversation.com/au"

        navigationItem.leftBarButtonItems = [back, reload, next]
        
        webView.navigationDelegate = self
        reloadDisplay.bringSubviewToFront(view)
    }
    
    @objc func backTapped() {
        webView.goBack()
        print("Back")
    }
    
    @objc func reloadTapped() {
        webView.reload()
        print("Reload")
    }
    
    @objc func nextTapped() {
        webView.goForward()
        print("Next")
    }

}

extension ViewController: WKNavigationDelegate, UIWebViewDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        reloadDisplay.startAnimating()
        print("start reloading")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        reloadDisplay.stopAnimating()
        print("stop reloading")
    }  // hide indicator

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        reloadDisplay.stopAnimating()
        print("error!!!")
    } // hide indicator*
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}

