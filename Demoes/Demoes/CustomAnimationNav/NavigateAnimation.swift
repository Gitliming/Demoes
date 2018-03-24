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
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
         origionPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: 0, height: 0))
         finalPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: 0, height: 0).insetBy(dx: -radiu, dy: -radiu))
        }else{
        origionPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: 0, height: 0).insetBy(dx: -radiu, dy: -radiu))
        finalPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: 0, height: 0))
        }
        
        let toVc = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromVc = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)
        let contentView = transitionContext?.containerView
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.3
        animation.fromValue = origionPath!.cgPath
        animation.toValue = finalPath!.cgPath
        animation.delegate = self
        let layer = CAShapeLayer()
        layer.path = finalPath!.cgPath
        layer.add(animation, forKey: "path")

        if isPush == true {
            contentView?.addSubview((toVc?.view)!)
            toVc?.view.layer.mask = layer
        }else{
            fromVc?.view.layer.mask = layer
            contentView?.addSubview((toVc?.view)!)
            contentView?.addSubview((fromVc?.view)!)
        }
    }
    
      func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(true)
        transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
        transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
                if !isPush {

        }
    }
}
