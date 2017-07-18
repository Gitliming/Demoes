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
    private var lineY:CGFloat?
    
    //线宽
    private var lineWidth:CGFloat = 0.5
    
    //线条颜色
    private let lineColor = UIColor.redColor()
    
    //圆弧半径
    private var radiu:CGFloat?
    

    override func drawRect(rect: CGRect) {
        
        lineY = rect.height - lineWidth - 49
        
        radiu = (rect.height - lineWidth*2)/2
        
        lineColor.set()
        
        
        //画左边直线
        let path1 = UIBezierPath()
        
        path1.lineWidth = lineWidth
        
        path1.lineCapStyle = .Round
        
        path1.lineJoinStyle = .Round
        
        path1.moveToPoint(CGPointMake(0, lineY!))
        
        //计算圆弧中间对应的弦长(勾股定理)
        
        let centerToTop = radiu! - lineY! + lineWidth
        
        let bb = pow(radiu!, 2) - pow(centerToTop, 2)
        
        let lineCenter = sqrt(bb)
        
        path1.addLineToPoint(CGPointMake(rect.width/2 - lineWidth - lineCenter, lineY!))
        

        
        //画中间圆弧
        
        let arcCenter = CGPointMake(rect.width/2, rect.height/2)//圆心
        
        let startAngle = CGFloat(M_PI) + asin(centerToTop/radiu!)
        
        let endAngle = startAngle + asin(lineCenter/radiu!)*2
        
        path1.addArcWithCenter(arcCenter, radius: radiu!, startAngle: startAngle, endAngle: endAngle, clockwise: true)//true为顺时针
        
        

        // 画右边线
        
        path1.addLineToPoint(CGPointMake(rect.width, lineY!))
        
        path1.stroke()
        
        
        
        //切除顶部空白
        
        let coverPath = UIBezierPath(rect: CGRectMake(0, lineY!, rect.width,rect.height - lineY!))
        
        coverPath.appendPath(UIBezierPath(roundedRect: CGRectMake((rect.width - rect.height)/2, 0, rect.height, rect.height), cornerRadius: radiu!))
        
        let clipLayer = CAShapeLayer()
        
        clipLayer.path = coverPath.CGPath
        
        layer.mask = clipLayer
        
        
    }
}
