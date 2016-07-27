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
    
    weak var locationDetailVC: LocationDetailViewController? = nil
    
    @IBOutlet weak var closeButtonBackgroundView: UIView! //只是为了补充白色
    @IBOutlet weak var closeButton: UIButton!
    
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
                            SOHO3Q_COOKIE_EXPIRE_DATE = NSDate(timeIntervalSinceNow: SOHO3Q_COOKIE_Expire_Time_Interval)
                            
                            PKHUD.sharedHUD.contentView = PKHUDProgressView()
                            PKHUD.sharedHUD.show()
                            
                            ProxyCreateOrderProcedure(sid, token: token) { [weak self] succeed, result in
                                guard let strongSelf = self else {
                                    return
                                }
                                if succeed {
                                    PKHUD.sharedHUD.hide(true, completion: { success in
                                        strongSelf.dismissViewControllerAnimated(true, completion: {
                                            UIAlertView.soho3q_showOrderAlert(result)
                                        })
                                        if let locationDetailVC = strongSelf.locationDetailVC {
                                            let sb = UIStoryboard(name: "Main", bundle: nil)
                                            if let paymentVC = sb.instantiateViewControllerWithIdentifier("PaymentViewController") as? PaymentViewController {
                                                paymentVC.couponOrder = result
                                                locationDetailVC.navigationController?.pushViewController(paymentVC, animated: true)
                                            }
                                        }
                                    })
                                } else {
                                    PKHUD.sharedHUD.hide(false)
                                }
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
            
        }
    }
}
