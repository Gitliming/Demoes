//
//  UIView + Extention.swift
//  Demoes
//
//  Created by xpming on 2016/12/1.
//  Copyright © 2016年 xpming. All rights reserved.
//

import Foundation
import UIKit
extension UIView{
    //获取所在控制器
    func getSelfController(view:UIView)->UIViewController?{
        var next:UIView? = view
        repeat{
            if let nextResponder = next?.nextResponder() where nextResponder.isKindOfClass(UIViewController.self){
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
}
