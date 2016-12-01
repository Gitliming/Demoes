//
//  DetailViewController.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/8.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = WaterView(frame:UIScreen.mainScreen().bounds)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit{
    
    print("detailVc  die......")
    }
}
