//
//  File.swift
//  Demoes
//
//  Created by 张丽明 on 2017/3/11.
//  Copyright © 2017年 xpming. All rights reserved.
//

import UIKit

let screenBounds = UIScreen.mainScreen().bounds
let screenWidth = screenBounds.width
let screenHeight = screenBounds.height
let screenScare = UIScreen.mainScreen().scale
private let dateFormatter = NSDateFormatter()

func asyn(mainTask:() -> Void) {
    dispatch_async(dispatch_get_main_queue(), mainTask)
}

func getCurrentTime(isWhole:Bool? = true) -> String{
    let timeInterver = NSDate().timeIntervalSinceNow
    let time = NSDate(timeIntervalSinceNow: timeInterver)
    if isWhole! {
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    }else{
        dateFormatter.dateFormat = "YYYY-MM-dd"
    }
    let timeString = dateFormatter.stringFromDate(time)
    return timeString
}
