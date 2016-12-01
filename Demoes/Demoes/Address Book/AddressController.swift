//
//  loginController.swift
//  Dispersive switch
//
//  Created by xpming on 16/7/7.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class AddressController: BaseViewController {
    var loginBtn:UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func prepareUI() {
        view.layer.contents = UIImage(named: "address_2")?.CGImage
        title = "进入通讯录"
        
        loginBtn = UIButton()
        loginBtn?.center = view.center
        loginBtn?.bounds.size = CGSize(width: 338, height: 95)
        loginBtn?.setTitle("获取通讯录", forState: .Normal)
        loginBtn?.setTitleColor(UIColor.greenColor(), forState: .Normal)
        loginBtn?.setBackgroundImage(UIImage(named: "loginBtn"), forState: .Normal)
        loginBtn?.addTarget(self, action: #selector(AddressController.login), forControlEvents: .TouchUpInside)
        view.addSubview(loginBtn!)
    }
    
    func login() {
        
        print("login")
    }

}
