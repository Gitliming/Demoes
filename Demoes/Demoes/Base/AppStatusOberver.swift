
//
//  AppStatusOberver.swift
//  Demoes
//
//  Created by 张丽明 on 2017/2/24.
//  Copyright © 2017年 xpming. All rights reserved.
//

import Foundation

class AppStatusOberver: NSObject {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("app进入--\(String(describing: change![NSKeyValueChangeKey.newKey]))")
    }
    deinit {
        removeObserver(self, forKeyPath: "appStatus")
    }
}
