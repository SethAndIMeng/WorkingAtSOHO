//
//  LoginViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/25.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

import Alamofire

class LoginViewController: WebViewController {
    
    @IBOutlet weak var closeButtonBackgroundView: UIView! //只是为了补充白色
    @IBOutlet weak var closeButton: UIButton!
    
    var loginSucceedCallback: ((succeed: Bool) -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "请登录您的SOHO3Q账户"
        
        webViewConstraintV0.constant = 20
        
        view.bringSubviewToFront(closeButtonBackgroundView)
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.setBackgroundImage(UIImage(named: "CloseButton2"), forState: .Normal)
        view.bringSubviewToFront(closeButton)
        closeButton.addTarget(self, action: #selector(CloseButtonPressed), forControlEvents: .TouchUpInside)
        
        if let url = NSURL(string: LoginUrl) {
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    override func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
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
                        if let token = result["token"], sid = result["sid"], user_phone = result["user_phone"] {
                            SOHO3Q_COOKIE_TOKEN = token
                            SOHO3Q_COOKIE_SID = sid
                            SOHO3Q_COOKIE_USER_PHONE = user_phone
                            SOHO3Q_COOKIE_TOKEN_SET_DATE = NSDate()
                            
                            //登录成功后记录此数据
                            Soho3QUserInfo.saveSoho3QUserInfo()
                            
                            self.loginSucceedCallback?(succeed: true)
                            self.dismissViewControllerAnimated(true) {
                                self.loginSucceedCallback = nil
                            }
                        }
                        
                    }
                })
                policy = .Cancel
            }
            
            decisionHandler(policy)
        } else {
            decisionHandler(.Allow)
        }
    }
    
    func CloseButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
            self.loginSucceedCallback = nil
        }
    }
}
