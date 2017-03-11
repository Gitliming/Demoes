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
   class func getSelfController(view:UIView)->UIViewController?{
        var next:UIView? = view
        repeat{
            if let nextResponder = next?.nextResponder() where nextResponder.isKindOfClass(UIViewController.self){
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
    
//    spliteLine 
    class func spliteLine(margin:CGFloat? = 10) -> UIView{
    let line = UIView(frame:CGRectMake(margin!, 0, screenWidth - 2 * margin!, 1/screenScare))
    line.backgroundColor = UIColor.groupTableViewBackgroundColor()
    return line
    }
    
}
