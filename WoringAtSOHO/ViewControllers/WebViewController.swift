//
//  WebViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/27.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit

import UIKit
import WebKit
import PKHUD

import Alamofire

class WebViewController: UIViewController, WKNavigationDelegate {
    
    weak var webView: WKWebView! = nil
    
    weak var webViewConstraintV0: NSLayoutConstraint! = nil
    weak var webViewConstraintV1: NSLayoutConstraint! = nil
    
    //共享的WKWebViewConfiguration
    static var defaultConfiguration: WKWebViewConfiguration {
        //        let token = UnsafeMutablePointer<dispatch_once_t>(unsafeAddressOf(defaultOnceToken)) //可以
        //        var token = UnsafeMutablePointer<dispatch_once_t>(&defaultOnceToken) //不行 Ambiguous use of 'init'
        //        let token = &defaultOnceToken //不行，原因：'&' can only appear immediately in a call argument list
        struct Static {
            static var configuration: WKWebViewConfiguration! = nil
            static var defaultOnceToken = dispatch_once_t(0)
        }
        func addUserScriptToUserContentController(userContentController: WKUserContentController) {
            if let jsHandler = try? (String(contentsOfURL: NSBundle.mainBundle().URLForResource("readCookie", withExtension: "js")!, encoding: NSUTF8StringEncoding) as String) {
                let jsScript = WKUserScript(source: jsHandler, injectionTime: .AtDocumentEnd, forMainFrameOnly: false)
                userContentController.addUserScript(jsScript)
            }
        }
        dispatch_once(&Static.defaultOnceToken) {
            let configuration = WKWebViewConfiguration()
            addUserScriptToUserContentController(configuration.userContentController)
            configuration.processPool = WKProcessPool()
            Static.configuration = configuration
        }
        return Static.configuration
    }
    
    override func loadView() {
        super.loadView()
        
        let defaultConfiguration = self.dynamicType.defaultConfiguration
        let strongWebView = WKWebView(frame: CGRectZero, configuration: defaultConfiguration)
        webView = strongWebView
        
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
//        let constrains1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(20)-[webView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView": webView])
//        view.addConstraints(constrains1)
        
        self.edgesForExtendedLayout = .None;
        
        webViewConstraintV0 = NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 20)
        webViewConstraintV1 = NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(webViewConstraintV0)
        view.addConstraint(webViewConstraintV1)
        #if false
            let constrains2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[webView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView": webView])
            view.addConstraints(constrains2)
        #else
            let constraint1 = NSLayoutConstraint(item: webView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 2)
            let constraint2 = NSLayoutConstraint(item: webView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -2)
            view.addConstraint(constraint1)
            view.addConstraint(constraint2)
        #endif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.Allow)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.Allow);
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        NSLog("%@-%@", userContentController, message)
    }
    
    deinit {
        webView.UIDelegate = nil
        webView.navigationDelegate = nil
    }
}