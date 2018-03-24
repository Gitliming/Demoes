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
        tableView = HomeView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .plain)
        tableView!.layer.contents = UIImage(named: "bg")?.cgImage
        view.addSubview(tableView!)
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "k"), for: UIBarMetrics.default)
        navigationController?.navigationBar.tintColor = UIColor.orange
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.purple]
    }
    
//裁剪图片
    func clipeImage(_ imageName:String?, imgWidth:CGFloat, imgHeight:CGFloat){
        
        guard let imgName = imageName else {return}
        var image = UIImage(named: imgName)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imgWidth+2, height: imgHeight+2), false, UIScreen.main.scale)
        let patch = UIBezierPath(arcCenter: CGPoint(x: (imgWidth / 2)+0.5,y: (imgHeight / 2)+0.5 ), radius: imgHeight / 2, startAngle: 0, endAngle:CGFloat(Double.pi * 2) , clockwise: true)
        patch.lineWidth = 1.0
        UIColor.clear.setFill()
        patch.stroke()
        patch.addClip()
        image?.draw(in: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let filePath = paths[0] + "\(String(describing: imageName)).png"
        try? UIImagePNGRepresentation(image!)?.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
        
        print(NSHomeDirectory())
    }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

