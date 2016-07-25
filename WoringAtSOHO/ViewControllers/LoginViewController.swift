//
//  LoginViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/25.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {

    weak var webView: WKWebView! = nil
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeButtonImageView: UIImageView!
    
    //共享的WKWebViewConfiguration
    static var defaultConfiguration: WKWebViewConfiguration {
//        let token = UnsafeMutablePointer<dispatch_once_t>(unsafeAddressOf(defaultOnceToken)) //可以
//        var token = UnsafeMutablePointer<dispatch_once_t>(&defaultOnceToken) //不行 Ambiguous use of 'init'
//        let token = &defaultOnceToken //不行，原因：'&' can only appear immediately in a call argument list
        struct Static {
            static var configuration: WKWebViewConfiguration! = nil
            static var defaultOnceToken = dispatch_once_t(0)
        }
        dispatch_once(&Static.defaultOnceToken) {
            Static.configuration = WKWebViewConfiguration()
            Static.configuration.processPool = WKProcessPool()
        }
        return Static.configuration
    }
    
    override func loadView() {
        super.loadView()
        
        let strongWebView = WKWebView(frame: CGRectZero, configuration: self.dynamicType.defaultConfiguration)
        webView = strongWebView
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
        
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(closeButtonImageView)
        
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

    @IBAction func CloseButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}
