//
//  RootTabBarView.swift
//  Demoes
//
//  Created by 张丽明 on 2017/7/2.
//  Copyright © 2017年 xpming. All rights reserved.
//

import UIKit

class RootTabBarView: UIView {
    
    //线条距底部位置
    fileprivate var lineY:CGFloat?
    
    //线宽
    fileprivate var lineWidth:CGFloat = 0.5
    
    //线条颜色
    fileprivate let lineColor = UIColor.red
    
    //圆弧半径
    fileprivate var radiu:CGFloat?
    

    override func draw(_ rect: CGRect) {
        
        lineY = rect.height - lineWidth - 49
        
        radiu = (rect.height - lineWidth*2)/2
        
        lineColor.set()
        
        
        //画左边直线
        let path1 = UIBezierPath()
        
        path1.lineWidth = lineWidth
        
        path1.lineCapStyle = .round
        
        path1.lineJoinStyle = .round
        
        path1.move(to: CGPoint(x: 0, y: lineY!))
        
        //计算圆弧中间对应的弦长(勾股定理)
        
        let centerToTop = radiu! - lineY! + lineWidth
        
        let bb = pow(radiu!, 2) - pow(centerToTop, 2)
        
        let lineCenter = sqrt(bb)
        
        path1.addLine(to: CGPoint(x: rect.width/2 - lineWidth - lineCenter, y: lineY!))
        

        
        //画中间圆弧
        
        let arcCenter = CGPoint(x: rect.width/2, y: rect.height/2)//圆心
        
        let startAngle = CGFloat(Double.pi) + asin(centerToTop/radiu!)
        
        let endAngle = startAngle + asin(lineCenter/radiu!)*2
        
        path1.addArc(withCenter: arcCenter, radius: radiu!, startAngle: startAngle, endAngle: endAngle, clockwise: true)//true为顺时针
        
        

        // 画右边线
        
        path1.addLine(to: CGPoint(x: rect.width, y: lineY!))
        
        path1.stroke()
        
        
        
        //切除顶部空白
        
        let coverPath = UIBezierPath(rect: CGRect(x: 0, y: lineY!, width: rect.width,height: rect.height - lineY!))
        
        coverPath.append(UIBezierPath(roundedRect: CGRect(x: (rect.width - rect.height)/2, y: 0, width: rect.height, height: rect.height), cornerRadius: radiu!))
        
        let clipLayer = CAShapeLayer()
        
        clipLayer.path = coverPath.cgPath
        
        layer.mask = clipLayer
        
        
    }
}
