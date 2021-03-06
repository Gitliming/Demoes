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
        view.frame = UIScreen.main.bounds
        view.layoutIfNeeded()
        shareContentView.layer.contents = UIImage(named: "share_bg")?.cgImage
        firstY = shareContentView.frame.origin.y
        shareContentView.frame.origin.y = view.frame.maxY
        animating(self.parent!)
        bindShareAction()
    }
    @IBAction func viewTap(_ sender: AnyObject) {
        animating(self.parent!)
    }
   func animating(_ parentCtrl:UIViewController) {
        if shareContentView.frame.maxY == view.frame.maxY{
            UIView.animate(withDuration: 0.3, animations: {
                self.shareContentView.frame.origin.y = self.view.frame.maxY
                }, completion: { (true) in
                    UIViewController.unshowViewController(parentCtrl, VC: self)
            })
        }else{
        UIView.animate(withDuration: 0.3, animations: {
            self.shareContentView.frame.origin.y = self.firstY!
            })
        }
    }
    //MARK:-- 绑定分享点击事件
    func bindShareAction (){
        let contentViews = shareContentView.subviews
        for v in contentViews {
            for btn in v.subviews{
                if btn.isKind(of: UIButton.self){
                (btn as! UIButton).addTarget(self, action: #selector(shareViewController.shareAction(_:)), for: .touchUpInside)
                }
            }
        }
    }
    func shareAction (_ button:UIButton){
        switch button.tag {
        case 0://QQ
            print(button.tag)
//            for i in 0 ..< 10000 {
//                if i % 1 == 0
//                && i % 2 == 1
//                && i % 3 == 0
//                && i % 4 == 1
//                && i % 5 == 1
//                && i % 6 == 3
//                && i % 7 == 0
//                && i % 8 == 1
//                    && i % 9 == 0 {
//                print("符合条件的\(i)")
//                }
//            }
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
