//
//  AppDelegate.swift
//  Demoes
//
//  Created by xpming on 2016/11/28.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //MARK:-- kvo测试app状态
   dynamic var appStatus:String?
    var appObserver:AppStatusOberver?
    
    var mapMannager:BMKMapManager?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        window = UIWindow(frame: screenBounds)
        
        let rootVc = RootTabBarController()
        
        window?.rootViewController = rootVc
        
        window?.makeKeyAndVisible()
        
        appObserver = AppStatusOberver()
        self.addObserver(appObserver!, forKeyPath: "appStatus", options: .new, context: nil)
        setMapMannager()
        appStatus = "launch---------"
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        appStatus = "inactive----------"
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        appStatus = "DidEnterBackground-----------"
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        appStatus = "WillEnterForeground----------"
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        appStatus = "active----------"
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        appStatus = "WillTerminate"
    }

    func setMapMannager(){
    mapMannager = BMKMapManager()
        let ret = mapMannager?.start("7v8PT4mrQB6vNiKtFUGsGZ7nVycEd0XV", generalDelegate: nil)
        if (ret == false) {
        print("****百度地图加载失败****")
        }
    }
}

