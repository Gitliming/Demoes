//
//  File.swift
//  Demoes
//
//  Created by 张丽明 on 2017/3/11.
//  Copyright © 2017年 xpming. All rights reserved.
//

import UIKit

let screenBounds = UIScreen.main.bounds
let screenWidth = screenBounds.width
let screenHeight = screenBounds.height
let screenScare = UIScreen.main.scale
private let dateFormatter = DateFormatter()

func asyn(_ mainTask:@escaping () -> Void) {
    DispatchQueue.main.async(execute: mainTask)
}

func asyn_global(_ mainTask:@escaping () -> Void){
    //DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: mainTask)
    DispatchQueue.global(qos: DispatchQoS.default.qosClass).async(execute: mainTask)
}


func weakSelf(_ obj:AnyObject) -> AnyObject? {
  weak var weakSelf = obj
    return weakSelf
}
func getCurrentTime(_ isWhole:Bool? = true) -> String{
    let timeInterver = Date().timeIntervalSinceNow
    let time = Date(timeIntervalSinceNow: timeInterver)
    if isWhole! {
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    }else{
        dateFormatter.dateFormat = "YYYY-MM-dd"
    }
    let timeString = dateFormatter.string(from: time)
    return timeString
}
func alert (_ title:String? = "", massage:String? = "",completion:(() -> (Void))? = nil){
    let vc = UIAlertController(title: title, message: massage, preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: "朕晓得了！", style: .default, handler: { (action) in
        vc.dismiss(animated: true, completion: nil)
        completion?()
    }))
    UIViewController.topViewController().present(vc, animated: true, completion: nil)
}
