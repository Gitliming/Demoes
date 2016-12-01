//
//  NavigateAnimation.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/8.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class NavigateAnimation: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    var transitionContext:UIViewControllerContextTransitioning?
    var isPush:Bool = false
    var imageRect:CGRect?
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        pushOrPopAnimation()
    }
    
    func pushOrPopAnimation(){
        let x = imageRect!.origin.x + (imageRect?.size.width)! / 2
        let y = imageRect!.origin.y + (imageRect?.size.height)! / 2
        let radiu = sqrt(x * x + y * y)
        var origionPath:UIBezierPath?
        var finalPath:UIBezierPath?
        if isPush == true {
         origionPath = UIBezierPath(ovalInRect: CGRectMake(x, y, 0, 0))
         finalPath = UIBezierPath(ovalInRect: CGRectInset(CGRectMake(x, y, 0, 0), -radiu, -radiu))
        }else{
        origionPath = UIBezierPath(ovalInRect: CGRectInset(CGRectMake(x, y, 0, 0), -radiu, -radiu))
        finalPath = UIBezierPath(ovalInRect: CGRectMake(x, y, 0, 0))
        }
        
        let toVc = transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVc = transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let contentView = transitionContext?.containerView()
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.3
        animation.fromValue = origionPath!.CGPath
        animation.toValue = finalPath!.CGPath
        animation.delegate = self
        let layer = CAShapeLayer()
        layer.path = finalPath!.CGPath
        layer.addAnimation(animation, forKey: "path")

        if isPush == true {
            contentView?.addSubview((toVc?.view)!)
            toVc?.view.layer.mask = layer
        }else{
            fromVc?.view.layer.mask = layer
            contentView?.addSubview((toVc?.view)!)
            contentView?.addSubview((fromVc?.view)!)
        }
    }
    
      func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(true)
        transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
        transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
                if !isPush {

        }
    }
}
