//
//  XYWebViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/4/3.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
class XYWebViewController: UIViewController,WKNavigationDelegate,UIImagePickerControllerDelegate,WKScriptMessageHandler {
    

    private let buttonRegion = CGFloat(44)
    
    
    private(set) var webView: WKWebView!
    
    private(set) var progressView: UIProgressView!
    
    private var topView:XYTopView!
    var urlString: String?
    var titleStr:String?
    var userContentController:WKUserContentController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatTopView()
        createWebView()
        if let _ = urlString {
            loadRequestUrl(urlString!)
        }
    }
    
    
    
    //创建自定义topview
    func creatTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        if titleStr != nil {
            topView.titleLabel.text = titleStr
        }
    }
    
    
    
    
    
    private  func createWebView() {
        let configuration = WKWebViewConfiguration()
        userContentController = WKUserContentController()
        userContentController.add(self, name: "clickBtn")

        configuration.userContentController = userContentController
        webView = WKWebView(frame: CGRect(x: 0, y: STATUS_NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - STATUS_NAV_HEIGHT), configuration: configuration)

        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        
        progressView = UIProgressView(frame: CGRect(x: 0, y: STATUS_NAV_HEIGHT-2, width: SCREEN_WIDTH, height: 2))
        progressView.progressTintColor = MAIN_GREEN
        progressView.trackTintColor = .clear
        view.addSubview(progressView)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new], context: nil)
    }
    
    //MARK: - 加载网页
    private func loadRequestUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }else{
            cmShowHUDToWindow(message: "链接地址无效")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - 监听
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                progressView.setProgress(0, animated: false)
            }
        }
    }
    

    
    

    
    //MARK: - 网页加载代理
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }
    
    
    

    

    
    //MARK: - 监听JS调用方法
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "clickBtn") {
            
            if let verificationStr = message.body as? String {
                cmDebugPrint(verificationStr)
            }
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
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

