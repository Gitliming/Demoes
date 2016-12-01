//
//  ScanView.swift
//  Dispersive switch
//
//  Created by xpming on 16/7/1.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class ScanView: UIView {
    enum scanType {
        case line
        case net
    }
    private var lineView:UIImageView?
    private var sView:UIImageView?
    private var displayLink:CADisplayLink?
    private var lineY:CGFloat?
    private var lineHeight:CGFloat = 14
    var scantype:scanType = .line
    var scanSpeed:CGFloat = 1  //1...5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        preperProperty(scantype)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preperProperty(scantype:scanType){
        self.layer.masksToBounds = true
        sView = UIImageView(frame: self.bounds)
        sView?.image = UIImage(named: "image_sweep")
        sView?.userInteractionEnabled = false
       
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
        lineView?.backgroundColor = UIColor.clearColor()
        lineView?.layer.shadowColor = lineView?.backgroundColor?.CGColor
        lineView?.layer.shadowOffset = CGSizeMake(0, -3)
        lineView?.layer.shadowOpacity = 1
        lineView?.layer.contentsScale = UIScreen.mainScreen().scale
        lineView?.userInteractionEnabled = false
        self.addSubview(sView!)
        self.addSubview(lineView!)
        
        displayLink = CADisplayLink(target: self, selector: #selector(ScanView.animating))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
    }
   
  @objc private func animating() {
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
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
    }
    func stopAnimating(){
        displayLink?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink = nil
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
