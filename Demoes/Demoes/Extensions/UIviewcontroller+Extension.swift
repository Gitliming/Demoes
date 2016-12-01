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
}
