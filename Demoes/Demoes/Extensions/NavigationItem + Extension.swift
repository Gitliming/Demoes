//
//  NavigationItem + Extension.swift
//  Dispersive switch
//
//  Created by xpming on 2016/11/30.
//  Copyright © 2016年 xpming. All rights reserved.
//

import Foundation
import UIKit
extension UINavigationItem {
    //MARK:--自定义导航按钮
    func setRightButton(title:String? = "", bgImgName:String? = "" ,button:UIButton){
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setTitle(title, forState: .Normal)
        button.setBackgroundImage(UIImage(named: bgImgName!), forState: .Normal)
        self.setRightBarButtonItem(UIBarButtonItem(customView: button), animated: true)
    }
}
