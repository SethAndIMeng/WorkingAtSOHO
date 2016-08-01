//
//  PaymentViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/27.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class MyReservationListViewController: BackButtonWebViewViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = NSURL(string: MyReservationListUrl) {
            let request = NSMutableURLRequest(URL: url)
            
            webView.loadRequest(request)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        //所有页面都需要去掉右上角的按钮
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC / 3/* 三分之一秒 */)), dispatch_get_main_queue(), {
            webView.evaluateJavaScript("seth_removeRightTopBarButton()", completionHandler: { (result, error) in
                print("seth_removeRightTopBarButton:\(result)")
            })
        })
    }
}

class PaymentViewController: BackButtonWebViewViewController {
    
    var currentUrlString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let orderID = couponOrder?.paymentOrderNum, url = NSURL(string: PaymentPrepareUrl + orderID) {
            let request = NSMutableURLRequest(URL: url)
            
            webView.loadRequest(request)
        }
    }
    
    override func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        var decision = WKNavigationActionPolicy.Allow
        if let url = navigationAction.request.URL {
            let urlString = url.absoluteString
            currentUrlString = urlString
            if nil != urlString.rangeOfString(PaymentSucceedUrl, options: .CaseInsensitiveSearch) {
                //支付成功页面
                decision = .Cancel
                
                paymentDoneCallback?(true)
                paymentDoneCallback = nil
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        decisionHandler(decision)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if let urlString = currentUrlString {
            if nil != urlString.rangeOfString(PaymentPrepareUrl, options: .CaseInsensitiveSearch)  {
                //为准备支付页
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC / 3/* 三分之一秒 */)), dispatch_get_main_queue(), {
                    webView.evaluateJavaScript("seth_hideProxyInfo()", completionHandler: { (result, error) in
                        print("seth_hideProxyInfo:\(result)")
                    })
                })
            }
        }
        //所有页面都需要去掉右上角的按钮
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC / 3/* 三分之一秒 */)), dispatch_get_main_queue(), {
            webView.evaluateJavaScript("seth_removeRightTopBarButton()", completionHandler: { (result, error) in
                print("seth_removeRightTopBarButton:\(result)")
            })
        })
    }
}

class BackButtonWebViewViewController: WebViewController {

    var couponOrder: ModelCouponOrder? = nil
    
    @IBOutlet weak var closeButtonBackgroundView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var paymentDoneCallback: ((Bool) -> ())? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.bringSubviewToFront(closeButtonBackgroundView)
        closeButtonBackgroundView.hidden = false
        closeButtonBackgroundView.backgroundColor = UIColor.whiteColor()
        closeButtonBackgroundView.layer.cornerRadius = 5
        closeButtonBackgroundView.layer.masksToBounds = true
        
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.setImage(UIImage(named: "GoBackButton"), forState: .Normal)
        closeButton.imageView?.contentMode = .ScaleAspectFit
        view.bringSubviewToFront(closeButton)
        closeButton.addTarget(self, action: #selector(CloseButtonPressed), forControlEvents: .TouchUpInside)
        
        title = "支付订单"
//        webViewConstraintV0.constant = -44

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func CloseButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
