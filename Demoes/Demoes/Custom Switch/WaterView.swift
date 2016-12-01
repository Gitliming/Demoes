//
//  WaterView.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/17.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class WaterView: UIView, UIGestureRecognizerDelegate {
    var displayLink:CADisplayLink?
    
    var shapLayerTop:CAShapeLayer?
    var shapLayerLeft:CAShapeLayer?
    
    var topTitleView:UIView?
    var leftTitleView:UIView?
    var listView:UIView?
    var topCtrlPoint:CGPoint = CGPointZero
    var leftCtrlPoint:CGPoint = CGPointZero
    var persentPan:CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        addPanGesture()
        creatSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatSubViews(){
        topTitleView = UIView(frame: CGRectMake(self.bounds.width / 2,0,5,5))
        topTitleView?.backgroundColor = UIColor.clearColor()
        leftTitleView = UIView(frame: CGRectMake(0,self.bounds.height / 2,5,5))
        leftTitleView?.backgroundColor = UIColor.clearColor()
        shapLayerTop = CAShapeLayer()
        shapLayerLeft = CAShapeLayer()
        self.layer.contents = UIImage(named: "20131018110819_LZhKK")?.CGImage
        shapLayerTop?.fillColor = UIColor.greenColor().CGColor
        shapLayerLeft?.fillColor = UIColor.greenColor().CGColor
        self.layer.addSublayer(shapLayerTop!)
        self.layer.addSublayer(shapLayerLeft!)
        self.addSubview(topTitleView!)
        self.addSubview(leftTitleView!)
    }
    
    func addPanGesture(){
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(WaterView.PanAction(_:)))
        self.userInteractionEnabled = true
        self.addGestureRecognizer(pan)
        
        displayLink = CADisplayLink(target: self, selector: #selector(WaterView.caculatePath))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink?.paused = true
    }
    
    func PanAction(panGesture:UIPanGestureRecognizer){
      let point = panGesture.translationInView(self)
        topTitleView?.frame = CGRectMake(self.bounds.width / 2 + point.x, point.y , 5, 5)
        if persentPan >= 0.3 {
            leftTitleView?.frame = CGRectMake(200, self.bounds.height / 2 + point.y, 5, 5)
        }else{
        leftTitleView?.frame = CGRectMake(point.x , self.bounds.height / 2 + point.y, 5, 5)
        }
        
        topCtrlPoint = (topTitleView?.layer.presentationLayer()?.position)!
        leftCtrlPoint = (leftTitleView?.layer.presentationLayer()?.position)!
        persentPan = point.x / self.bounds.width
        print(persentPan)
       updateWaterPath()
        panGestureEnd(panGesture)
    }
    
    func panGestureEnd(panGesture:UIPanGestureRecognizer){
        
        if panGesture.state == UIGestureRecognizerState.Ended {
            self.displayLink?.paused = false
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.topTitleView?.frame = CGRectMake(self.bounds.width / 2, 0, 5, 5)
                if self.persentPan >= 0.3 {
                    self.leftTitleView?.frame = CGRectMake(200, self.bounds.height / 2, 5, 5)
                }else{
                   self.leftTitleView?.frame = CGRectMake(0, self.bounds.height / 2, 5, 5)
                }
                
                self.updateWaterPath()
                
                }, completion: { (true) in
                    
                    self.displayLink?.paused = true
            })
        }
    }
    
    func updateWaterPath(){
        
        let pathTop = UIBezierPath()
        pathTop.moveToPoint(CGPointMake(0, 0))
        pathTop.addLineToPoint(CGPointMake(self.bounds.width, 0))
        pathTop.addQuadCurveToPoint(CGPointMake(0, 0), controlPoint: topCtrlPoint)
        pathTop.closePath()
        shapLayerTop?.path = pathTop.CGPath
        
        let pathLeft = UIBezierPath()
        
        if persentPan >= 0.3 {
            pathLeft.moveToPoint(CGPointMake(200, 0))
            pathLeft.addLineToPoint(CGPointMake(0, 0))
            pathLeft.addLineToPoint(CGPointMake(0, self.bounds.height))
            pathLeft.addLineToPoint(CGPointMake(200, self.bounds.height))
            pathLeft.addQuadCurveToPoint(CGPointMake(200, 0), controlPoint: leftCtrlPoint)
        }else{
            pathLeft.moveToPoint(CGPointMake(0, 0))
            pathLeft.addLineToPoint(CGPointMake(0, self.bounds.height))
            pathLeft.addQuadCurveToPoint(CGPointMake(0, 0), controlPoint: leftCtrlPoint)
        }
        
        
        shapLayerLeft?.path = pathLeft.CGPath
    }
    
    func caculatePath(){
        let poTop = (topTitleView?.layer.presentationLayer()?.position)!
        let poLeft = (leftTitleView?.layer.presentationLayer()?.position)!
        topCtrlPoint = CGPointMake(poTop.x, poTop.y - 2.5)
        leftCtrlPoint = CGPointMake(poLeft.x - 2.5, poLeft.y)
        updateWaterPath()
    }
}
