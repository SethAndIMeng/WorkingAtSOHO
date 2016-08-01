//
//  MyReservationListViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/8/1.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import WebKit

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
