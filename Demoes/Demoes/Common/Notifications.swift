//
//  Notifications.swift
//  Demoes
//
//  Created by 张丽明 on 2017/3/11.
//  Copyright © 2017年 xpming. All rights reserved.
//

import Foundation

struct Notifications {
    static let notificationCenter = NotificationCenter.default
//    通知注册处：
    static var beginInputNote = delegate(name: "UITextViewTextDidBeginEditingNotification")
    
    class delegate {
        fileprivate let name:String
        
        init(name:String) {
            self.name = name
        }
        
//        MARK:-- post notification
        func post(_ object:AnyObject?){
            asyn {
                notificationCenter.post(name: Notification.Name(rawValue: self.name), object: object)
            }
        }
        
//        MARK:-- add observer
        func addObserve(_ observer:AnyObject, object:AnyObject?, selecter:Selector) {
            notificationCenter.addObserver(observer, selector: selecter, name: NSNotification.Name(rawValue: name), object:object )
        }
        
//        MARK:remove observer
        func removeObserver(_ observer:AnyObject, sender object:AnyObject?){
            notificationCenter.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: observer)
        }
        
//        MARK:-- remove All Observer
        func removeAllObserver(_ observer:AnyObject) {
            notificationCenter.removeObserver(observer)
        }
    }
}
