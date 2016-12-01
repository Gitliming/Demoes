//
//  ViewController.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/6.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    var btnInitFrame:CGRect?
    var tableView:HomeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        
        setUpUI()

        }
//添加按钮
    func setUpUI(){
        
        ///首页
        tableView = HomeView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height), style: .Plain)
        tableView!.layer.contents = UIImage(named: "bg")?.CGImage
        view.addSubview(tableView!)
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "k"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.purpleColor()]
    }
    
//裁剪图片
    func clipeImage(imageName:String?, imgWidth:CGFloat, imgHeight:CGFloat){
        
        guard let imgName = imageName else {return}
        var image = UIImage(named: imgName)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgWidth+2, imgHeight+2), false, UIScreen.mainScreen().scale)
        let patch = UIBezierPath(arcCenter: CGPoint(x: (imgWidth / 2)+0.5,y: (imgHeight / 2)+0.5 ), radius: imgHeight / 2, startAngle: 0, endAngle:CGFloat(M_PI * 2) , clockwise: true)
        patch.lineWidth = 1.0
        UIColor.clearColor().setFill()
        patch.stroke()
        patch.addClip()
        image?.drawInRect(CGRectMake(0, 0, imgWidth, imgHeight))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let filePath = paths[0].stringByAppendingString("\(imageName).png")
        UIImagePNGRepresentation(image!)?.writeToFile(filePath, atomically: true)
        
        print(NSHomeDirectory())
    }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

