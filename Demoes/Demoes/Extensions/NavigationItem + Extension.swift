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
    func setRightButton(_ title:String? = "", bgImgName:String? = "" ,button:UIButton){
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setTitle(title, for: UIControlState())
        button.setBackgroundImage(UIImage(named: bgImgName!), for: UIControlState())
        self.setRightBarButton(UIBarButtonItem(customView: button), animated: true)
    }
}
