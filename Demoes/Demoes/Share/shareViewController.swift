//
//  shareViewController.swift
//  Dispersive switch
//
//  Created by xpming on 2016/11/29.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class shareViewController: BaseViewController {
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
        bindShareAction()
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
    //MARK:-- 绑定分享点击事件
    func bindShareAction (){
        let contentViews = shareContentView.subviews
        for v in contentViews {
            for btn in v.subviews{
                if btn.isKindOfClass(UIButton){
                (btn as! UIButton).addTarget(self, action: #selector(shareViewController.shareAction(_:)), forControlEvents: .TouchUpInside)
                }
            }
        }
    }
    func shareAction (button:UIButton){
        switch button.tag {
        case 0://QQ
            print(button.tag)
        case 1://QZone
            print(button.tag)
        case 2://weichat
            print(button.tag)
        case 3://friends
            print(button.tag)
        case 4://xinlang
            print(button.tag)
        case 5://wangye
            print(button.tag)
        case 6://refresh
            print(button.tag)
        case 7://youjian
            print(button.tag)

        default: break
        }
    }
}
