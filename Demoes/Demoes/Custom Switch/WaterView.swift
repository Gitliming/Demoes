//
//  WaterView.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/17.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class WaterView: UIView, UIGestureRecognizerDelegate {
    var displayLink:CADisplayLink?
    
    var shapLayerTop:CAShapeLayer?
    var shapLayerLeft:CAShapeLayer?
    
    var topTitleView:UIView?
    var leftTitleView:UIView?
    var listView:UIView?
    var topCtrlPoint:CGPoint = CGPoint.zero
    var leftCtrlPoint:CGPoint = CGPoint.zero
    var persentPan:CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        addPanGesture()
        creatSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatSubViews(){
        topTitleView = UIView(frame: CGRect(x: self.bounds.width / 2,y: 0,width: 5,height: 5))
        topTitleView?.backgroundColor = UIColor.clear
        leftTitleView = UIView(frame: CGRect(x: 0,y: self.bounds.height / 2,width: 5,height: 5))
        leftTitleView?.backgroundColor = UIColor.clear
        shapLayerTop = CAShapeLayer()
        shapLayerLeft = CAShapeLayer()
        self.layer.contents = UIImage(named: "20131018110819_LZhKK")?.cgImage
        shapLayerTop?.fillColor = UIColor.green.cgColor
        shapLayerLeft?.fillColor = UIColor.green.cgColor
        self.layer.addSublayer(shapLayerTop!)
        self.layer.addSublayer(shapLayerLeft!)
        self.addSubview(topTitleView!)
        self.addSubview(leftTitleView!)
    }
    
    func addPanGesture(){
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(WaterView.PanAction(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(pan)
        
        displayLink = CADisplayLink(target: self, selector: #selector(WaterView.caculatePath))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        displayLink?.isPaused = true
    }
    
    func PanAction(_ panGesture:UIPanGestureRecognizer){
      let point = panGesture.translation(in: self)
        topTitleView?.frame = CGRect(x: self.bounds.width / 2 + point.x, y: point.y , width: 5, height: 5)
        if persentPan >= 0.3 {
            leftTitleView?.frame = CGRect(x: 200, y: self.bounds.height / 2 + point.y, width: 5, height: 5)
        }else{
        leftTitleView?.frame = CGRect(x: point.x , y: self.bounds.height / 2 + point.y, width: 5, height: 5)
        }
        
        topCtrlPoint = (topTitleView?.layer.presentation()?.position)!
        leftCtrlPoint = (leftTitleView?.layer.presentation()?.position)!
        persentPan = point.x / self.bounds.width
        print(persentPan ?? description)
       updateWaterPath()
        panGestureEnd(panGesture)
    }
    
    func panGestureEnd(_ panGesture:UIPanGestureRecognizer){
        
        if panGesture.state == UIGestureRecognizerState.ended {
            self.displayLink?.isPaused = false
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: UIViewAnimationOptions(), animations: {
                self.topTitleView?.frame = CGRect(x: self.bounds.width / 2, y: 0, width: 5, height: 5)
                if self.persentPan >= 0.3 {
                    self.leftTitleView?.frame = CGRect(x: 200, y: self.bounds.height / 2, width: 5, height: 5)
                }else{
                   self.leftTitleView?.frame = CGRect(x: 0, y: self.bounds.height / 2, width: 5, height: 5)
                }
                
                self.updateWaterPath()
                
                }, completion: { (true) in
                    
                    self.displayLink?.isPaused = true
            })
        }
    }
    
    func updateWaterPath(){
        
        let pathTop = UIBezierPath()
        pathTop.move(to: CGPoint(x: 0, y: 0))
        pathTop.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        pathTop.addQuadCurve(to: CGPoint(x: 0, y: 0), controlPoint: topCtrlPoint)
        pathTop.close()
        shapLayerTop?.path = pathTop.cgPath
        
        let pathLeft = UIBezierPath()
        
        if persentPan >= 0.3 {
            pathLeft.move(to: CGPoint(x: 200, y: 0))
            pathLeft.addLine(to: CGPoint(x: 0, y: 0))
            pathLeft.addLine(to: CGPoint(x: 0, y: self.bounds.height))
            pathLeft.addLine(to: CGPoint(x: 200, y: self.bounds.height))
            pathLeft.addQuadCurve(to: CGPoint(x: 200, y: 0), controlPoint: leftCtrlPoint)
        }else{
            pathLeft.move(to: CGPoint(x: 0, y: 0))
            pathLeft.addLine(to: CGPoint(x: 0, y: self.bounds.height))
            pathLeft.addQuadCurve(to: CGPoint(x: 0, y: 0), controlPoint: leftCtrlPoint)
        }
        
        
        shapLayerLeft?.path = pathLeft.cgPath
    }
    
    func caculatePath(){
        let poTop = (topTitleView?.layer.presentation()?.position)!
        let poLeft = (leftTitleView?.layer.presentation()?.position)!
        topCtrlPoint = CGPoint(x: poTop.x, y: poTop.y - 2.5)
        leftCtrlPoint = CGPoint(x: poLeft.x - 2.5, y: poLeft.y)
        updateWaterPath()
    }
}
