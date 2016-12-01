//
//  NCViewController.swift
//  text
//
//  Created by xpming on 16/4/21.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class NCViewController: BaseViewController, UIGestureRecognizerDelegate {
    @IBOutlet var NEwView: UIView!
    
    var name:String?
    var xib:UIView?
    var pan:UIPanGestureRecognizer?
    var startPan:CGPoint?
    var index = 0
    var previousView:UIView?
    let rect = UIScreen.mainScreen().bounds
    let width = UIScreen.mainScreen().bounds.width
    let preRect = CGRect(x: -UIScreen.mainScreen().bounds.width, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)

    override func viewDidLoad() {
        super.viewDidLoad()

        name = "zhangsan"
        view!.layer.contents = UIImage(named: "f")?.CGImage
        setUp()
        
    }
    func setUp () {
        let button = UIButton()
        button.addTarget(self, action: #selector(NCViewController.share), forControlEvents: .TouchUpInside)
        navigationItem.setRightButton(bgImgName: "share_btn", button:button)
//    let vs = NSBundle.mainBundle().loadNibNamed("textXIb", owner: nil, options: nil)
//        
//        xib = vs[0] as? UIView
//        
//    xib?.frame = self.view.bounds
//    
//    
//    self.view.addSubview(xib!)
//2.手势添加
        pan = UIPanGestureRecognizer(target:self, action:#selector(NCViewController.panAction(_:)))
        pan?.delegate = self
         view.addGestureRecognizer(pan!)
       
         addPages()
                 }
    
    func share() {
        if self.childViewControllers.count < 1{
        let shareVc = shareViewController(nibName: "shareViewController", bundle: nil)
            UIViewController.showViewController(self, VC: shareVc)
        }
    }
//    添加需要切换的页面
    func addPages(){
        
        xib = textXIb(frame: self.view.bounds)
        let view1 = UIView(frame: rect)
        let imageView1 = UIImageView(frame: rect)
        imageView1.image = UIImage(named: "e")
        view1.addSubview(imageView1)
        view1.backgroundColor = UIColor.lightGrayColor()
        let view2 = UIView(frame: rect)
        view2.backgroundColor = UIColor.brownColor()
        let imageView2 = UIImageView(frame: rect)
        imageView2.image = UIImage(named: "d")
        
        view2.addSubview(imageView2)
        let view3 = UIView(frame: rect)
        view3.backgroundColor = UIColor.yellowColor()
        let imageView3 = UIImageView(frame: rect)
        imageView3.image = UIImage(named: "c")
        
        view3.addSubview(imageView3)
        view.insertSubview(view1, atIndex: 0)
        view.insertSubview(view2, atIndex: 1)
        view.insertSubview(view3, atIndex: 2)
        view.insertSubview(xib!, atIndex: 3)
        index = view.subviews.count - 1

    }
//    手势实现切换逻辑
    func panAction(panGestu:UIPanGestureRecognizer){

        let point = panGestu.locationInView(view)
        let move = point.x - (startPan?.x)!
        let panMove = move / width
        let targetView = view.subviews[index]
        if panMove > 0 {
            if index < 3{
            previousView = view.subviews[index + 1]
            previousView!.frame = CGRectOffset(preRect, move, 0)
            }
        }else{
        targetView.frame = CGRectOffset(rect, move, 0)
        }
        if panGestu.state == UIGestureRecognizerState.Ended {
            if panMove < -0.5 {
                if index == 0{
                    UIView.animateWithDuration(0.5, animations: {
                        targetView.frame = self.rect
                    })

                }else{
                    UIView.animateWithDuration(0.5, animations: {
                        
                        targetView.frame = CGRectOffset(self.rect, -self.width, 0)
                    })

                }
                if index > 0 {
                    index -= 1
                }
            }else if panMove < 0 && panMove >= -0.5 {
                UIView.animateWithDuration(0.5, animations: {
                    targetView.frame = self.rect
                })
                
                
            }else if panMove < 0.5 && panMove >= 0 {
                guard let pre = previousView else {
                    UIView.animateWithDuration(0.5, animations: {
                        targetView.frame = self.rect
                    })

                    return
                }
                UIView.animateWithDuration(0.5, animations: {
                     pre.frame = self.preRect
                })
                if index == view.subviews.count - 1 {
                    UIView.animateWithDuration(0.5, animations: {
                        targetView.frame = self.rect
                    })
                }
            } else {
                if index == view.subviews.count - 1 {
                    guard let pre = previousView else {
                        
                    UIView.animateWithDuration(0.5, animations: {
                            targetView.frame = self.rect
                        })
                        return
                    }
                    UIView.animateWithDuration(0.5, animations: {
                        pre.frame = self.preRect
                        targetView.frame = self.rect
                    })

                }else {
                    guard let pre = previousView else {return}
                    UIView.animateWithDuration(0.5, animations: {
                        pre.frame = self.rect
                    })
                }
                if index < 3{
                 index += 1
                }
            }

        }
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        startPan = gestureRecognizer.locationInView(view)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    }
