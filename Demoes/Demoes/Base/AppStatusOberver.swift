//
//  AppStatusOberver.swift
//  Demoes
//
//  Created by 张丽明 on 2017/2/24.
//  Copyright © 2017年 xpming. All rights reserved.
//

import Foundation

class AppStatusOberver: NSObject {

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print("app进入--\(change![NSKeyValueChangeNewKey])")
    }
    deinit {
        removeObserver(self, forKeyPath: "appStatus")
    }
}
