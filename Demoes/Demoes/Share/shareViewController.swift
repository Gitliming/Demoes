//
//  shareViewController.swift
//  Dispersive switch
//
//  Created by xpming on 2016/11/29.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class shareViewController: UIViewController {
    @IBOutlet weak var shareContentView: UIView!
    var firstY:CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI() {
        shareContentView.layer.contents = UIImage(named: "share_bg")?.CGImage
        firstY = shareContentView.frame.origin.y
        shareContentView.frame.origin.y = view.frame.maxY
        animating(self.parentViewController!)
    }
    @IBAction func viewTap(sender: AnyObject) {
        animating(self.parentViewController!)
    }
   func animating(parentCtrl:UIViewController) {
        if shareContentView.frame.maxY == view.frame.maxY{
            UIView.animateWithDuration(0.3, animations: {
                self.shareContentView.frame.origin.y = self.view.frame.maxY
                }, completion: { (true) in
                    UIViewController.unshowViewController(parentCtrl, VC: self)
            })
        }else{
        UIView.animateWithDuration(0.3, animations: {
            self.shareContentView.frame.origin.y = self.firstY!
            })
        }
    }
}
