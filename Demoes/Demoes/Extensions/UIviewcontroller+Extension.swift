//
//  UIviewcontroller+Extension.swift
//  Dispersive switch
//
//  Created by xpming on 2016/11/30.
//  Copyright © 2016年 xpming. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    //MARK:-- 添加子控制器
    class func showViewController(parentVC:UIViewController, VC:UIViewController){
        if parentVC.childViewControllers.count < 1 {
        parentVC.addChildViewController(VC)
        parentVC.view.addSubview(VC.view)
        }
    }
    //MARK:-- 移除子控制器
    class func unshowViewController(parentVC:UIViewController, VC:UIViewController){
        if parentVC.childViewControllers.count > 0 {
            VC.removeFromParentViewController()
            VC.view.removeFromSuperview()
        }
    }
    //MARK:--根据类名转换类
    class func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
            //            let indexStart = appName.startIndex.advancedBy(10)
            //            let indexEnd = appName.endIndex.advancedBy(-6)
            //            let subStr = appName.substringToIndex(indexStart)
            //            let subStr2 = appName.substringFromIndex(indexEnd)
            //            let endName = "\(subStr)_\(subStr2)" 如果appName中有空格，会用“——”代替

            let classStringName = "\(appName).\(className)"
            // return the class!
            return NSClassFromString(classStringName)
        }
        return nil;
    }
    //MARK:-- 获取最上层控制器
    class func topViewController() -> UIViewController{
    let rootVc = UIApplication.sharedApplication().keyWindow?.rootViewController?.childViewControllers.first
        return rootVc!
    }
}
