//
//  ScanView.swift
//  Dispersive switch
//
//  Created by xpming on 16/7/1.
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


class ScanView: UIView {
    enum scanType {
        case line
        case net
    }
    fileprivate var lineView:UIImageView?
    fileprivate var sView:UIImageView?
    fileprivate var displayLink:CADisplayLink?
    fileprivate var lineY:CGFloat?
    fileprivate var lineHeight:CGFloat = 14
    var scantype:scanType = .line
    var scanSpeed:CGFloat = 1  //1...5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        preperProperty(scantype)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func preperProperty(_ scantype:scanType){
        self.layer.masksToBounds = true
        sView = UIImageView(frame: self.bounds)
        sView?.image = UIImage(named: "image_sweep")
        sView?.isUserInteractionEnabled = false
       
        if scantype == .line {
            lineHeight = 14
            lineY = sView!.frame.minY - lineHeight
            lineView = UIImageView(frame:CGRect(x: sView!.frame.origin.x, y: lineY!, width: sView!.frame.size.width, height: lineHeight))
            lineView?.image = UIImage(named: "line")
        }else{
            lineHeight = sView!.frame.size.height
            lineY = sView!.frame.minY - lineHeight
            lineView = UIImageView(frame:CGRect(x: sView!.frame.origin.x, y: lineY!, width: sView!.frame.size.width, height: lineHeight))
            lineView?.image = UIImage(named: "scan_net")
        }
        lineView?.backgroundColor = UIColor.clear
        lineView?.layer.shadowColor = lineView?.backgroundColor?.cgColor
        lineView?.layer.shadowOffset = CGSize(width: 0, height: -3)
        lineView?.layer.shadowOpacity = 1
        lineView?.layer.contentsScale = UIScreen.main.scale
        lineView?.isUserInteractionEnabled = false
        self.addSubview(sView!)
        self.addSubview(lineView!)
        
        displayLink = CADisplayLink(target: self, selector: #selector(ScanView.animating))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
    }
   
  @objc fileprivate func animating() {
        lineView?.frame = CGRect(x: sView!.frame.origin.x, y: lineY!, width: sView!.frame.size.width, height: lineHeight)
        lineY = lineY!+scanSpeed
    switch scantype {
    case .line:
        if lineY >= (sView?.frame.maxY)! - lineHeight {
            lineY = sView!.frame.minY
        }
    default:
        if lineY >= sView?.frame.origin.y {
        lineY = (sView?.frame.minY)! - lineHeight
        }
    }
    }
    func startAnimating() {
        displayLink = CADisplayLink(target: self, selector: #selector(ScanView.animating))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
    }
    func stopAnimating(){
        displayLink?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        displayLink = nil
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if scantype == .line {
        scantype = .net
        }else{
        scantype = .line
        }
        lineView?.removeFromSuperview()
        sView?.removeFromSuperview()
        stopAnimating()
        preperProperty(scantype)
    }
}
