//
//  Notifications.swift
//  Demoes
//
//  Created by 张丽明 on 2017/3/11.
//  Copyright © 2017年 xpming. All rights reserved.
//

import Foundation

struct Notifications {
    static let notificationCenter = NSNotificationCenter.defaultCenter()
//    通知注册处：
    static var beginInputNote = delegate(name: "beginInputNote")
    
    class delegate {
        private let name:String
        
        init(name:String) {
            self.name = name
        }
        
//        MARK:-- post notification
        func post(object:AnyObject?){
            asyn { 
                notificationCenter.postNotificationName(self.name, object: object)
            }
        }
        
//        MARK:-- add observer
        func addObserve(observer:AnyObject, object:AnyObject?, selecter:Selector) {
            notificationCenter.addObserver(observer, selector: selecter, name: name, object:object )
        }
        
//        MARK:remove observer
        func removeObserver(observer:AnyObject, sender object:AnyObject?){
            notificationCenter.removeObserver(observer, name: name, object: observer)
        }
        
//        MARK:-- remove All Observer
        func removeAllObserver(observer:AnyObject) {
            notificationCenter.removeObserver(observer)
        }
    }
}
