//
//  ShowQRController.swift
//  Dispersive switch
//
//  Created by xpming on 16/6/23.
//  Copyright © 2016年 xpming. All rights reserved.
//

import UIKit

class ShowQRController: UIViewController {
    var QrImgView:UIImageView?
    var saveButton:UIButton?
    var message:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        drawQrImage()
    }
    
    func setupUI(){
        title = "二维码"
        view.layer.contents = UIImage(named: "j")?.CGImage
        QrImgView = UIImageView(frame: CGRect(origin: view.center, size: CGSizeMake(150, 150)))
        QrImgView?.center = view.center
        QrImgView?.backgroundColor = UIColor.whiteColor()
        let y = QrImgView?.frame.maxY
        saveButton = UIButton(frame: CGRect(x: (view.bounds.width - 100)/2, y: y! + 20, width: 100, height: 40))
        saveButton?.setTitle("保存图片", forState: UIControlState.Normal)
        saveButton?.setBackgroundImage(UIImage(named:"l"), forState: UIControlState.Normal)
        saveButton?.addTarget(self, action: #selector(ShowQRController.saveImage), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(QrImgView!)
        view.addSubview(saveButton!)
        
    }
    
    func saveImage(){
        UIImageWriteToSavedPhotosAlbum((QrImgView?.image)!, self, #selector(ShowQRController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        print("saveSucceful")
    }
    
    func image(image:UIImage?, didFinishSavingWithError:NSError?, contextInfo: AnyObject?){
        var Err = ""
        
        if didFinishSavingWithError != nil {
            Err = "保存失败！"
        }else{
        
            Err = "保存成功！"
        }
        
      let alertCtrl = UIAlertController(title: "提示", message: Err, preferredStyle: .Alert)
    let alertAction = UIAlertAction(title: "sure", style: .Default, handler: nil)
        
        alertCtrl.addAction(alertAction)
        self.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    
    
    
    func drawQrImage() {
        //获取生成的图片
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        if message == "" {
        
        message = "请输入内容。。。"
        }
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)
        filter?.setValue( data, forKey: "inputMessage")
        var QrImg = filter?.outputImage
        
        //设置二维码的前背景色
        let filterColor = CIFilter(name: "CIFalseColor")
        filterColor?.setDefaults()
        filterColor?.setValue(QrImg, forKeyPath: "inputImage")
        
        ///获取生成的图片无损放大
        QrImg = filterColor?.outputImage
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(QrImg!, fromRect: (QrImg?.extent)!)
        //添加中心标志图
        var QRImage = UIImage(CGImage: cgImage!)
        
        UIGraphicsBeginImageContext((QrImgView?.bounds.size)!)
        let titleImg = UIImage(named: "m")
        let resetContext = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(resetContext!, CGInterpolationQuality.None)
        QRImage.drawInRect(CGRectMake(10, 10, QrImgView!.bounds.size.width - 20, QrImgView!.bounds.size.height - 20))
        let rect = CGRectMake((QrImgView!.bounds.size.width - 30)/2,
                              (QrImgView!.bounds.size.height - 30)/2,
                              30, 30)
        titleImg?.drawInRect(rect)
        
        QRImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        QrImgView?.image = QRImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
