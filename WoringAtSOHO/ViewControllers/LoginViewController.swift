//
//  LoginViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/25.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import WebKit
import WebViewJavascriptBridge

class LoginViewController: UIViewController, WKNavigationDelegate {

    weak var webView: WKWebView! = nil
    weak var webViewBridge: WKWebViewJavascriptBridge! = nil
    @IBOutlet weak var closeButtonBackgroundView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
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
        webViewBridge = WKWebViewJavascriptBridge(forWebView: webView)
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let constrains1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(20)-[webView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView": webView])
        view.addConstraints(constrains1)
        #if false
            let constrains2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[webView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView": webView])
            view.addConstraints(constrains2)
        #else
            let constraint1 = NSLayoutConstraint(item: webView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 2)
            let constraint2 = NSLayoutConstraint(item: webView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -2)
            view.addConstraint(constraint1)
            view.addConstraint(constraint2)
        #endif
        
        view.bringSubviewToFront(closeButtonBackgroundView)
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.setBackgroundImage(UIImage(named: "CloseButton2"), forState: .Normal)
        view.bringSubviewToFront(closeButton)
        
        if let url = NSURL(string: LoginUrl) {
            webView.loadRequest(NSURLRequest(URL: url))
        }
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
        
        if let url = navigationAction.request.URL {
            var policy = WKNavigationActionPolicy.Allow
            let urlString = url.absoluteString
            if nil != urlString.rangeOfString(LoginUrl, options: .CaseInsensitiveSearch)  {
                //为登录页
                
            } else if nil != urlString.rangeOfString(RegisterUrl, options: .CaseInsensitiveSearch) {
                //注册页
            } else {
                webView.evaluateJavaScript("seth_get3QUserIdentity()", completionHandler: { (result, error) in
                    if let result = result as? [String: String] {
                        if let token = result["token"] {
                            SOHO3Q_USER_TOKEN = token
                            #if DEBUG
                                UIAlertView(title: "token", message: "\(token)", delegate: nil, cancelButtonTitle: "OK").show()
                            #endif
                        }
                        if let sid = result["sid"] {
                            SOHO3Q_USER_SID = sid
                            #if DEBUG
                                UIAlertView(title: "sid", message: "\(sid)", delegate: nil, cancelButtonTitle: "OK").show()
                            #endif
                        }
                        self.dismissViewControllerAnimated(true, completion: {
                            
                        })
                    }
                })
                policy = .Cancel
            }
            
            decisionHandler(policy)
        } else {
            decisionHandler(.Allow)
        }
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.Allow);
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        NSLog("%@-%@", userContentController, message)
    }

    @IBAction func CloseButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    deinit {
        webView.UIDelegate = nil
        webView.navigationDelegate = nil
    }
}
