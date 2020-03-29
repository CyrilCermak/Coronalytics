//
//  BaseWebView.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 27.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import UIKit
import WebKit

class BaseWebView: BaseVC {
    private var navTitle: String = ""
    
    let webView = WKWebView(frame: UIScreen.main.bounds)
    
    convenience init(url: URLRequest, title: String? = nil) {
        self.init(nibName: nil, bundle: nil)
        webView.load(url)
    }
    
    convenience init(localFileName: String, title: String? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.navTitle = title ?? ""
        if let url = Bundle.main.url(forResource: localFileName, withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCloseBtn()
        styleNavigation()
        title = navTitle
        webView.navigationDelegate = self
        webView.alpha = 0
    }
    
    override func loadView() {
        self.view = webView
    }
    
    private func styleNavigation() {
        navigationController?.navigationBar.backgroundColor = .cvGrey
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func setCloseBtn() {
        let closeBtn = UIBarButtonItem(image: UIImage(named: "close_button"), style: .plain, target: self, action: #selector(self.didClickClose))
        self.navigationItem.rightBarButtonItem = closeBtn
    }
    
    @objc func didClickClose() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BaseWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.3) {
            webView.alpha = 1
        }
    }
}

