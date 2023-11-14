//
//  WKWebView+.swift
//  CodeFantasia
//
//  Created by Daisy Hong on 2023/11/14.
//

import UIKit
import WebKit
import SnapKit

extension WKWebView: WKNavigationDelegate, WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "호출!" {
            print("정상 호출 됨.")
        }
    }
    
    func setWebView(url: String) {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "호출!")
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = contentController
        
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            configuration.preferences.javaScriptEnabled = true
        }

        self.navigationDelegate = self
        
        let urlString = url
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        self.load(request)
    }

}
