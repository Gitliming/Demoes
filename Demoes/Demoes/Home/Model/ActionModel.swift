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
                                      "通讯录":"AddressController",
                                      "江南笔记":"MyNoteViewController",
                                      "OC与JS交互":"WebViewController",
                                      "地图导航":"BMKViewController"]
    var modelArray = [Model]()
    override init() {
        super.init()
        if ActionList.count == 0 {return}
        for (k, v) in ActionList {
            var vc:AnyClass?
            if k == "OC与JS交互" || k == "地图导航"{
                 vc = NSClassFromString(v)
            }else{
                 vc = UIViewController.swiftClassFromString(v)
            }
            
            let mod = Model()
            if vc == nil {continue}
            mod.ActionName = k
            mod.ActionVc = vc
            modelArray.append(mod)
        }
    }
    func swiftClassFromString(_ className: String) -> AnyClass! {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
        //  如果appName中有空格，会用“——”代替
            let classStringName = "\(appName).\(className)"
        // return the class!
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}
