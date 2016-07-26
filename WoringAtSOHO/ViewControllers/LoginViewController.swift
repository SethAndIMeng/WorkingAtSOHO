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

class LoginViewController: UIViewController, WKNavigationDelegate {

    weak var webView: WKWebView! = nil
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
                        if let token = result["token"], sid = result["sid"], user_phone = result["user_phone"] {
                            SOHO3Q_COOKIE_TOKEN = token
                            SOHO3Q_COOKIE_SID = sid
                            SOHO3Q_COOKIE_USER_PHONE = user_phone
                            
                            PKHUD.sharedHUD.contentView = PKHUDProgressView()
                            PKHUD.sharedHUD.show()
                            
                            Alamofire.request(.POST, GetUserInfoAPIUrl,
                                parameters: nil,
                                encoding: .URL,
                                headers: [
                                    "Content-Type": "application/x-www-form-urlencoded",
                                    "Accept-Encoding": "gzip, deflate",
                                    "Cookie": "sid=\(sid); token=\(token)"]
                                )
                                .validate()
                                .responseObject(completionHandler: {
                                    [weak self] (response: Response<ModelGetUserInfo, NSError>) in
                                    
                                    switch response.result {
                                    case .Success:
                                        guard let strongSelf = self else {
                                            return
                                        }
                                        var type = Soho3QProxyOrderType.RMB99
//                                        var title = "不是会员"
//                                        var message = "走￥99流程"
                                        if let result = response.result.value?.result {
                                            if let memberType = result.memberType {
                                                switch memberType {
                                                case "Float":
                                                    fallthrough
                                                case "Fix":
                                                    fallthrough
                                                case "Both":
                                                    //已经是会员
//                                                    title = "已经是会员"
//                                                    message = "走￥120流程"
                                                    type = .RMB120
                                                    break;
                                                    
                                                default:
                                                    //不是会员
                                                    break;
                                                }
                                            }
                                            
                                            ProxyAccountLogin { succeed in
                                                if succeed {
                                                    ProxyCreateOrder(type) { succeed in
                                                        if succeed {
                                                            PKHUD.sharedHUD.hide(true, completion: { success in
                                                                strongSelf.dismissViewControllerAnimated(true, completion: {
//                                                                    UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "确定").show()
                                                                })
                                                            })
                                                        } else {
                                                            PKHUD.sharedHUD.hide(false)
                                                        }
                                                    }
                                                } else {
                                                    PKHUD.sharedHUD.hide(false)
                                                }
                                            }
                                        } else {
                                            PKHUD.sharedHUD.hide(false)
                                        }
                                        break
                                    case .Failure:
                                        PKHUD.sharedHUD.hide(false)
                                        break
                                    }
                                })
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
