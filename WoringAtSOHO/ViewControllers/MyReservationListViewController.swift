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
    
    @IBOutlet weak var exitButton: UIButton!
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
            webView.evaluateJavaScript("seth_removeRightTopBarButton()", completionHandler: { [weak self] (result, error) in
                print("seth_removeRightTopBarButton:\(result)")
                if let strongSelf = self {
                    strongSelf.view.bringSubviewToFront(strongSelf.exitButton)
                }
            })
        })
    }
    @IBAction func exitButtonPressed(sender: AnyObject) {
        let alertView = UIAlertView(title: "", message: "是否退出登录?", delegate: self, cancelButtonTitle: "取消")
        alertView.addButtonWithTitle("退出")
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.navigationController?.popViewControllerAnimated(true)
            Soho3QUserInfo.resetSoho3QUserInfo()
        }
        
    }
}
