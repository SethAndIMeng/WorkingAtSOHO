//
//  AppDelegate.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/14.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: NSBundle.mainBundle())
        if let launchViewController = storyboard.instantiateInitialViewController() {
            
            //代码启动，便于之后加动画
            let window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window.rootViewController = launchViewController
            self.window = window
            window.makeKeyAndVisible()

            var sleepTime = Int64(2 * NSEC_PER_SEC)
            #if DEBUG
                sleepTime = 0
            #endif
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sleepTime), dispatch_get_main_queue(), { [weak self] in
                
                let barAppearace = UIBarButtonItem.appearance()
                barAppearace.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics:UIBarMetrics.Default)
                
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let mainViewController = storyboard.instantiateInitialViewController()
                if let window = self?.window {
                    window.rootViewController = mainViewController
                }
            })
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

