//
//  ActionModel.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/14.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class ActionModel: NSObject {
    var ActionList:[String:String] = ["推拉门式转场":"NCViewController",
                                      "自定义转场":"DetailViewController",
                                      "二维码部落":"InputController",
                                      "通讯录":"AddressController"]
    var modelArray = [Model]()
    override init() {
        super.init()
        if ActionList.count == 0 {return}
        for (k, v) in ActionList {
            
            let mod = Model()
            let vc:AnyClass? = swiftClassFromString(v)
            if vc == nil {continue}
            mod.ActionName = k
            mod.ActionVc = vc
            modelArray.append(mod)
        }
        
    }
    func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
//            let indexStart = appName.startIndex.advancedBy(10)
//            let indexEnd = appName.endIndex.advancedBy(-6)
//            let subStr = appName.substringToIndex(indexStart)
//            let subStr2 = appName.substringFromIndex(indexEnd)
//            let endName = "\(subStr)_\(subStr2)"
            let classStringName = "\(appName).\(className)"
        // return the class!
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}
