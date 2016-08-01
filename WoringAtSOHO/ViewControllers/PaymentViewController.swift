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

class PaymentViewController: WebViewController {

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
//        if let url = NSURL(string: PaymentFormSubmitUrl) {
//            
//            if let couponOrder = couponOrder,
//                order_id = couponOrder.paymentOrderId,
//                order_num = couponOrder.paymentOrderNum,
//                bill_id = couponOrder.paymentBillId,
//                order_amount = couponOrder.totalPrice?.description {
//                
//                let project_id = ""
//                let channel = "0"
//                let parameters =
//                    "order_id=" + order_num +
//                        "&order_num=" + order_num +
//                        "&bill_id=" + order_id +
//                        "&order_amount=" + order_amount +
//                        "&project_id=" + project_id +
//                        "&channel=" + channel +
//                "&url=url"
//                
//                let request = NSMutableURLRequest(URL: url)
//                request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", forHTTPHeaderField: "Accept")
//                request.setValue("zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4,nb;q=0.2", forHTTPHeaderField: "Accept-Language")
//                request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
//                request.setValue("gzip, deflate, sdch", forHTTPHeaderField: "Accept-Encoding")
//                request.setValue("sid=\(SOHO3Q_COOKIE_SID); token=\(SOHO3Q_COOKIE_TOKEN)", forHTTPHeaderField: "Cookie")
//                request.setValue(HostUrl, forHTTPHeaderField: "Host")
//                request.setValue(PaymentPrepareUrl + order_num, forHTTPHeaderField: "Referer")
//                request.HTTPMethod = "POST"
//                request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
//                webView.loadRequest(request)
//            }
//        }
        if let orderID = couponOrder?.paymentOrderNum, url = NSURL(string: PaymentPrepareUrl + orderID) {
            let request = NSMutableURLRequest(URL: url)
            
            webView.loadRequest(request)
        }
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
    
    var currentUrlString: String? = nil
    
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
                
//                UIAlertView(title: "支付成功", message: "支付成功了，可以兑换了", delegate: nil, cancelButtonTitle: "确定").show()
                
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
    
    func CloseButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
