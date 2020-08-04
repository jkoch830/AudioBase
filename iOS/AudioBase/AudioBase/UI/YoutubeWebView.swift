//
//  YoutubeWebView.swift
//  AudioBase
//
//  Created by James Koch on 8/3/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import WebKit
import UIKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:self.getStartURL())
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func getStartURL() -> String {
        return ""
    }
    
    func getCurrentURL() -> String {
        return self.webView.url!.absoluteString
    }
}

struct WebViewControllerWrapper: UIViewControllerRepresentable {

    typealias RepresentableContext = UIViewControllerRepresentableContext<WebViewControllerWrapper>
    
    var webViewController: WebViewController

    func makeUIViewController(context: RepresentableContext) -> UIViewController {
        return self.webViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController,
                                context: RepresentableContext) {
        //
    }
    
    func getCurrentURL() -> String {
        return self.webViewController.getCurrentURL()
    }
}

class YoutubeWebViewController: WebViewController {
    override func getStartURL() -> String {
        return "https://www.youtube.com/"
    }
}

struct YoutubeWebView: View {
    var webViewControllerWrapper: WebViewControllerWrapper =
        WebViewControllerWrapper(webViewController: YoutubeWebViewController())
    
    func getCurrentURL() -> String {
        return self.webViewControllerWrapper.getCurrentURL()
    }
    
    var body: some View {
        self.webViewControllerWrapper
    }
}
