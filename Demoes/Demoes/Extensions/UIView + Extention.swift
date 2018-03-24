//
//  UIView + Extention.swift
//  Demoes
//
//  Created by xpming on 2016/12/1.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit
extension UIView{
//获取所在控制器
   class func getSelfController(_ view:UIView)->UIViewController?{
        var next:UIView? = view
        repeat{
            if let nextResponder = next?.next, nextResponder.isKind(of: UIViewController.self){
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
    
//    spliteLine 
    class func spliteLine(_ margin:CGFloat? = 10) -> UIView{
    let line = UIView(frame:CGRect(x: margin!, y: 0, width: screenWidth - 2 * margin!, height: 1/screenScare))
    line.backgroundColor = UIColor.lightGray
    return line
    }
    
}
