//
//  CustomAnimaViewNavigation.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/8.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class CustomAnimaViewNavigation: UINavigationController , UINavigationControllerDelegate {
    var isPush:Bool = false
    //动画的起始位置
    var imageRect:CGRect?    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func pushViewController(viewController: UIViewController,Rect:CGRect, animated: Bool) {
        self.delegate = self
        imageRect = Rect
        isPush = true
        
        super.pushViewController(viewController, animated: true)
    }
    
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        isPush = false
        
        return super.popViewControllerAnimated(true)
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animatedTransition = NavigateAnimation()
        animatedTransition.isPush = isPush
        animatedTransition.imageRect = imageRect
        if !isPush {
            
            self.delegate = nil
        }
        return animatedTransition
    }
}
